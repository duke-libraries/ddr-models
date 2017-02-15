module Ddr::Models
  module HasMultiresImage
    extend ActiveSupport::Concern

    included do
      has_file_datastream name: Ddr::Datastreams::MULTIRES_IMAGE,
                          type: Ddr::Datastreams::MultiresImageDatastream,
                          label: "Multi-resolution image derivative for this object",
                          control_group: "E"
    end

    def multires_image_file_path
      datastreams[Ddr::Datastreams::MULTIRES_IMAGE].file_path
    end

  end
end
