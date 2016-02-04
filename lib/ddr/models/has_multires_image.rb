module Ddr::Models
  module HasMultiresImage
    extend ActiveSupport::Concern

    included do
      property :multires_image_file_path, predicate: Ddr::Vocab::Asset.multiresImageFilePath, multiple: false
    end

    def deletion_event_payload
      super.merge(multires_image_file_path: multires_image_file_path)
    end

  end
end
