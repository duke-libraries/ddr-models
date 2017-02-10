module Ddr::Models
  module FileManagement
    extend ActiveSupport::Concern

    included do
      attr_accessor :file_to_add

      define_model_callbacks :add_file
      before_add_file :virus_scan

      after_save :notify_virus_scan_results

      # Deleting the datastream external files on destroying the object can't
      # be handled with a datastream around_destroy callback.
      # See https://groups.google.com/d/msg/hydra-tech/xJaZr2wVhbg/4iafvso98w8J
      around_destroy :cleanup_external_files_on_destroy
    end

    # add_file(file, dsid, opts={})
    #
    # Comparable to Hydra::ModelMethods#add_file(file, dsid, file_name)
    #
    # Options:
    #
    #   :mime_type - Explicit mime type to set (otherwise discerned from file path or name)
    #
    #   :original_name - A String value will be understood as the original name of the file.
    #                    `false` or `nil` indicate that the file basename is not the original
    #                    name. Default processing will take the file basename as the original
    #                    name.
    #
    #   :external - Add to file to external datastream. Not required for datastream specs
    #               where :control_group=>"E".
    #
    #   :use_original - For external datastream file, do not copy file to new file path,
    #                   but use in place (set dsLocation to file URI for current path.
    def add_file(file, dsid, opts={})
      opts[:mime_type] ||= Ddr::Utils.mime_type_for(file)

      # @file_to_add is set for callbacks to access the data
      original_name = opts.fetch(:original_name, Ddr::Utils.file_name_for(file))
      self.file_to_add = FileToAdd.new(file, dsid, original_name)

      run_callbacks(:add_file) do
        if opts.delete(:external) || datastreams.include?(dsid) && datastreams[dsid].external?
          add_external_file(file, dsid, opts)
        else
          file = File.new(file, "rb") if Ddr::Utils.file_path?(file)
          # ActiveFedora method accepts file-like objects, not paths
          add_file_datastream(file, dsid: dsid, mimeType: opts[:mime_type])
        end
      end

      # clear the instance data
      self.file_to_add = nil
    end

    # @api private
    # Normally this method should not be called directly.
    # Call `add_file` with dsid for external datastream, or with
    # `:external=>true` option if no spec for dsid.
    def add_external_file(file, dsid, opts={})
      file_path = Ddr::Utils.file_path(file) # raises ArgumentError
      ds = datastreams[dsid] || add_external_datastream(dsid)
      unless ds.external?
        raise ArgumentError, "Cannot add external file to datastream with controlGroup \"#{ds.controlGroup}\""
      end
      ds.add_file(file_path, opts.slice(:mime_type))
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

    FileToAdd = Struct.new(:file, :dsid, :original_name)

    def virus_scan_results
      @virus_scan_results ||= []
    end

    def virus_scan
      path = Ddr::Utils.file_path(file_to_add[:file])
      virus_scan_results << Ddr::Actions::VirusCheck.call(path)
    rescue ArgumentError => e # file is a blob
      logger.error(e)
    end

    def notify_virus_scan_results
      while result = virus_scan_results.shift
        result.merge! pid: pid
        ActiveSupport::Notifications.instrument(Ddr::Notifications::VIRUS_CHECK, result)
      end
    end

    def cleanup_external_files_on_destroy
      paths = external_datastream_file_paths
      yield
      File.unlink *paths
    end

  end
end
