module Ddr
  module Models
    module HasMezzanine
      extend ActiveSupport::Concern

      included do
        has_file_datastream name: Ddr::Datastreams::MEZZANINE,
                            versionable: true,
                            label: "Mezzanine file for this object",
                            control_group: 'M'

        include FileManagement unless include?(FileManagement)
      end

    end
  end
end
