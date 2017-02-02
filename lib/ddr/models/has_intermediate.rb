module Ddr
  module Models
    module HasIntermediate
      extend ActiveSupport::Concern

      included do
        has_file_datastream name: Ddr::Datastreams::INTERMEDIATE,
                            versionable: true,
                            label: "Intermediate file for this object",
                            control_group: 'M'

        include FileManagement unless include?(FileManagement)
      end

    end
  end
end
