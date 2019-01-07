module Ddr
  module Models
    module HasIntermediateFile
      extend ActiveSupport::Concern

      included do
        # has_file_datastream name: Ddr::Datastreams::INTERMEDIATE_FILE,
        #                     type: Ddr::Datastreams::IntermediateFileDatastream,
        #                     versionable: true,
        #                     label: "Intermediate file for this object",
        #                     control_group: "E"

        include FileManagement
      end

      def intermediate_type
        datastreams[Ddr::Datastreams::INTERMEDIATE_FILE].mimeType
      end

      def intermediate_extension
        extensions = Ddr::Models.preferred_file_extensions
        if extensions.include? intermediate_type
          extensions[intermediate_type]
        else
          intermediate_extension_default
        end
      end

      def intermediate_path
        datastreams[Ddr::Datastreams::INTERMEDIATE_FILE].file_path
      end

      private

      def intermediate_extension_default
        datastreams[Ddr::Datastreams::INTERMEDIATE_FILE].default_file_extension
      end

    end
  end
end
