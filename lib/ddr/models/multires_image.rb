require "uri"

module Ddr::Models
  class MultiresImage < ExternalFile

    USE = "multi-res"

    def initialize(file_path)
      super.tap do |mri|
        mri.location = "file:#{file_path}"
        mri.use = USE
        mri.mime_type = Ddr::Utils.mime_type_for(file_path)
        mri.resource_type = "Image"
      end
    end

    def file_path
      URI.parse(location.first).path
    end

  end
end
