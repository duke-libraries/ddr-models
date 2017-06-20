module Ddr::Models
  class MediaType

    def self.call(file_or_path)
      path = file_or_path.respond_to?(:path) ? file_or_path.path : file_or_path
      # Use preferred media type, if available
      media_type = Ddr::Models.preferred_media_types[File.extname(path)]
      if !media_type
        if file_or_path.respond_to?(:content_type)
          # Rails ActionDispatch::Http::UploadedFile
          media_type = file_or_path.content_type
        else
          # Fall back to first MIME type or default
          mime_types = MIME::Types.of(path)
          media_type = mime_types.empty? ? Ddr::Models.default_mime_type : mime_types.first.content_type
        end
      end
      media_type
    end

  end
end
