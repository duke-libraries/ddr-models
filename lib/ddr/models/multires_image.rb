module Ddr::Models
  class MultiresImage < ExternalFile

    USE = "multi-res"

    def initialize(file_path, mime_type: nil)
      super(use: USE, resource_type: 'Image', location: file_path, mime_type: mime_type)
    end

  end
end
