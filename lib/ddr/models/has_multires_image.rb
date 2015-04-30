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

      def multires_image_file_path
        URI.parse(datastreams[Ddr::Datastreams::MULTIRES_IMAGE].dsLocation).path if datastreams[Ddr::Datastreams::MULTIRES_IMAGE].dsLocation
      end

    end
  end
end
