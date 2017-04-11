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

    def streamable_media_path
      datastreams[Ddr::Datastreams::STREAMABLE_MEDIA].file_path
    end

  end
end
