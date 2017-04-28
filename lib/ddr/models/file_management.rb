module Ddr::Models
  module FileManagement
    extend ActiveSupport::Concern

    included do
      define_model_callbacks :add_file
      before_add_file :virus_scan
      after_add_file :set_original_filename
      after_save :create_virus_check_event
    end

    FileToAdd = Struct.new(:dsid, :source_path, :original_filename)

    # @param file [String, File, ActionDispatch::Http::UploadedFile]
    #   The file, or path to file, to add.
    # @param dsid [String] The datastream ID to which file should be added.
    # @param mime_type [String] Explicit mime type to set
    #   (otherwise discerned from file path or name).
    # @param external [Boolean] Add file to external datastream.
    #   Not required for external datastream classes
    #   or datastream instances having controlGroup 'E'.
    def add_file(file, dsid, mime_type: nil, external: false, original_filename: nil)
      mime_type         ||= Ddr::Utils.mime_type_for(file)
      source_path         = Ddr::Utils.file_path(file)
      original_filename ||= Ddr::Utils.file_name(file)
      file_to_add = FileToAdd.new(dsid, source_path, original_filename)
      cache.with(file_to_add: file_to_add) do
        run_callbacks(:add_file) do
          if external || ( datastreams.include?(dsid) && datastreams[dsid].external? )
            add_external_file(file, dsid, mime_type: mime_type)
          else
            add_file_datastream(file, dsid: dsid, mimeType: mime_type)
          end
        end
      end
    end

    def add_file_datastream(file, opts={})
      if Ddr::Utils.file_path?(file)
        file = File.new(file, "rb")
      end
      super
    end

    # @api private
    # Normally this method should not be called directly.
    # Call `add_file` with dsid for external datastream, or with
    # `:external=>true` option if no spec for dsid.
    def add_external_file(file, dsid, mime_type: nil)
      file_path = Ddr::Utils.file_path(file) # raises ArgumentError
      ds = datastreams[dsid] || add_external_datastream(dsid)
      unless ds.external?
        raise ArgumentError, "Cannot add external file to non-external datastream."
      end
      ds.add_file(file_path, mime_type: mime_type)
    end

    def external_datastreams
      datastreams.values.select { |ds| ds.external? }
    end

    def external_datastream_file_paths
      external_datastreams.map(&:file_paths).flatten
    end

    def add_external_datastream dsid, opts={}
      create_datastream(Ddr::Datastreams::ExternalFileDatastream, dsid).tap do |ds|
        add_datastream(ds)
        self.class.build_datastream_accessor(dsid)
      end
    end

    protected

    def virus_scan
      file_to_add = cache.get(:file_to_add)
      result = Ddr::Actions::VirusCheck.call(file_to_add.source_path)
      if file_to_add.dsid == Ddr::Datastreams::CONTENT
        cache.put(:virus_scan_result, result)
      end
    rescue ArgumentError => e # file is a blob (string)
      logger.error(e)
    end

    def create_virus_check_event
      if result = cache.get(:virus_scan_result)
        Ddr::Events::VirusCheckEvent.create(result.merge(pid: pid))
      end
    end

    def set_original_filename
      if file_to_add = cache.get(:file_to_add)
        if file_to_add.dsid == Ddr::Datastreams::CONTENT
          self.original_filename = file_to_add.original_filename
        end
      end
    end

  end
end
