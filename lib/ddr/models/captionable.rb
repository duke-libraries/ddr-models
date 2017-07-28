module Ddr::Models
  module Captionable
    extend ActiveSupport::Concern

    included do
      has_file_datastream name: Ddr::Datastreams::CAPTION,
                          type: Ddr::Datastreams::CaptionDatastream,
                          versionable: true,
                          label: "Caption file for this object",
                          control_group: "E"
    end

    def caption_path
      datastreams[Ddr::Datastreams::CAPTION].file_path
    end

  end
end
