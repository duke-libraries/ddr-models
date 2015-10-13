module Ddr
  module Models
    module HasMultiresImage
      extend ActiveSupport::Concern

      included do
        contains Ddr::Datastreams::MULTIRES_IMAGE
      end

      def multires_image_file_path
        URI.parse(datastreams[Ddr::Datastreams::MULTIRES_IMAGE].dsLocation).path if datastreams[Ddr::Datastreams::MULTIRES_IMAGE].dsLocation
      end

    end
  end
end
