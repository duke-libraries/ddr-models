module Ddr
  module Models
    module HasMultiresImage
      extend ActiveSupport::Concern

      included do
        property :multires_image_file_path, predicate: Ddr::Vocab::Asset.multiresImageFilePath, multiple: false
      end

    end
  end
end
