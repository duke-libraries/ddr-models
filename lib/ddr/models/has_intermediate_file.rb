module Ddr
  module Models
    module HasIntermediateFile
      extend ActiveSupport::Concern

      included do
        has_file_datastream name: Ddr::Datastreams::INTERMEDIATE_FILE,
                            type: Ddr::Datastreams::IntermediateFileDatastream,
                            versionable: true,
                            label: "Intermediate file for this object",
                            control_group: "E"

        include FileManagement
      end

    end
  end
end
