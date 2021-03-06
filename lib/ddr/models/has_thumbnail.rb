module Ddr
  module Models
    module HasThumbnail
      extend ActiveSupport::Concern

      included do
        has_file_datastream name: Ddr::Datastreams::THUMBNAIL,
                            versionable: true,
                            label: "Thumbnail for this object",
                            control_group: 'M'
      end

      def thumbnail_changed?
        thumbnail.content_changed?
      end

      def copy_thumbnail_from(other)
        if other && other.has_thumbnail?
          self.thumbnail.content = other.thumbnail.content
          self.thumbnail.mimeType = other.thumbnail.mimeType if thumbnail_changed?
        end
        thumbnail_changed?
      end

    end
  end
end
