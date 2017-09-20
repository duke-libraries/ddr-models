module Ddr::Models
  module Streamable
    extend ActiveSupport::Concern

    included do
      has_file_datastream name: Ddr::Datastreams::STREAMABLE_MEDIA,
                          type: Ddr::Datastreams::StreamableMediaDatastream,
                          versionable: true,
                          label: "Streamable media file for this object",
                          control_group: "E"
    end

    def streamable_media_type
      datastreams[Ddr::Datastreams::STREAMABLE_MEDIA].mimeType
    end

    def streamable_media_extension
      extensions = Ddr::Models.preferred_file_extensions
      if extensions.include? streamable_media_type
        extensions[streamable_media_type]
      else
        streamable_media_extension_default
      end
    end

    def streamable_media_path
      datastreams[Ddr::Datastreams::STREAMABLE_MEDIA].file_path
    end

    private

    def streamable_media_extension_default
      datastreams[Ddr::Datastreams::STREAMABLE_MEDIA].default_file_extension
    end

  end
end
