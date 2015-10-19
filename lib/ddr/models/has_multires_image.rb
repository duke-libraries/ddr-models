module Ddr
  module Models
    module HasMultiresImage
      extend ActiveSupport::Concern

      def multires_image
        external_files.detect { |ef| ef.use.first == MultiresImage::USE }
      end

      def multires_image_file_path
        if mri = multires_image
          mri.file_path
        end
      end

    end
  end
end
