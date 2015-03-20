module Ddr
  module Models
    module HasMultiresImage
      extend ActiveSupport::Concern
  
      included do
        has_file_datastream name: Ddr::Datastreams::MULTIRES_IMAGE,
                            label: "Multi-resolution image derivative for this object",
                            control_group: 'E'

        include FileManagement unless include?(FileManagement)
      end

    end
  end
end