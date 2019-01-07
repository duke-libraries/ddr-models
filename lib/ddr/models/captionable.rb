module Ddr::Models
  module Captionable
    extend ActiveSupport::Concern

    # included do
    #   has_file_datastream name: Ddr::Datastreams::CAPTION,
    #                       type: Ddr::Datastreams::CaptionDatastream,
    #                       versionable: true,
    #                       label: "Caption file for this object",
    #                       control_group: "E"
    # end
    #
    def caption_type
      datastreams[Ddr::Datastreams::CAPTION].mimeType
    end

    def caption_extension
      extensions = Ddr::Models.preferred_file_extensions
      if extensions.include? caption_type
        extensions[caption_type]
      else
        caption_extension_default
      end
    end

    def caption_path
      datastreams[Ddr::Datastreams::CAPTION].file_path
    end

    private

    def caption_extension_default
      datastreams[Ddr::Datastreams::CAPTION].default_file_extension
    end

  end
end
