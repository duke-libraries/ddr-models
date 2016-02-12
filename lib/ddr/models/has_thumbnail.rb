module Ddr::Models
  module HasThumbnail
    extend ActiveSupport::Concern

    included do
      contains Ddr::Models::File::THUMBNAIL, class_name: "Ddr::Models::File"
    end

    def thumbnail_changed?
      thumbnail.content_changed?
    end

    def copy_thumbnail_from(other)
      if other && other.has_thumbnail?
        self.thumbnail.content = other.thumbnail.content
        self.thumbnail.mime_type = other.thumbnail.mime_type if thumbnail_changed?
      end
      thumbnail_changed?
    end

  end
end
