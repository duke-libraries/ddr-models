module Ddr::Models
  module FileManagement
    extend ActiveSupport::Concern

    included do
      attr_accessor :file_to_add

      define_model_callbacks :add_file
      before_add_file :virus_scan

      after_save :notify_virus_scan_results

    end

    # Adds ActiveFedora::File
    # Overrides ActiveFedora::AttachedFiles#add_file(file, opts)
    #
    # Options:
    #
    #   :path - The path of the child resource to create
    #
    #   :mime_type - Explicit mime type to set (otherwise discerned from file path or name)
    #
    #   :original_name - A String value will be understood as the original name of the file.
    #                    Default processing will take the file basename as the original name.
    def add_file file, opts={}
      opts[:mime_type] ||= Ddr::Utils.mime_type_for(file)
      opts[:original_name] ||= Ddr::Utils.file_name_for(file)

      # @file_to_add is set for callbacks to access the data
      self.file_to_add = file

      run_callbacks(:add_file) do
        super
      end

      # clear the instance data
      self.file_to_add = nil
    end

    protected

    FileToAdd = Struct.new(:file, :dsid, :original_name)

    def virus_scan_results
      @virus_scan_results ||= []
    end

    def virus_scan
      path = Ddr::Utils.file_path(file_to_add)
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

  end
end
