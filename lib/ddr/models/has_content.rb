require 'openssl'

module Ddr
  module Models
    module HasContent
      extend ActiveSupport::Concern

      included do
        has_file_datastream name: Ddr::Datastreams::CONTENT,
                            versionable: true, 
                            label: "Content file for this object",
                            control_group: "M"

        has_attributes :original_filename, datastream: "adminMetadata", multiple: false

        include Hydra::Derivatives
        include FileManagement unless include?(FileManagement)

        around_save :update_thumbnail, if: :content_changed?

        after_add_file do
          if file_to_add.original_name && file_to_add.dsid == "content"
            self.original_filename = file_to_add.original_name 
          end
        end

        delegate :validate_checksum!, to: :content

        index :content_control_group,    :searchable, type: :string
        index :content_media_major_type, :facetable
        index :content_media_sub_type,   :facetable
        index :content_media_type,       :symbol
        index :content_size,             :stored_sortable, type: :integer
        index :content_size_human,       :symbol
        index :last_virus_check_on,      :stored_sortable, type: :date
        index :last_virus_check_outcome, :symbol
      end

      # Convenience method wrapping FileManagement#add_file
      def upload file, opts={}
        add_file(file, Ddr::Datastreams::CONTENT, opts)
      end

      # Set content to file and save
      def upload! file, opts={}
        upload(file, opts)
        save
      end

      def content_size
        content.external? ? content.file_size : content.dsSize
      end

      def content_human_size
        ActiveSupport::NumberHelper.number_to_human_size(content_size) if content_size
      end
      alias_method :content_size_human, :content_human_size

      def content_type
        content.mimeType
      end
      alias_method :content_media_type, :content_type

      def content_major_type
        content_type.split("/").first if content_type
      end
      alias_method :content_media_major_type, :content_major_type

      def content_sub_type
        content_type.split("/").last if content_type
      end
      alias_method :content_media_sub_type, :content_sub_type

      def content_type= mime_type
        self.content.mimeType = mime_type
      end

      def image?
        content_major_type == "image"
      end

      def pdf?
        content_type == "application/pdf"
      end

      def generate_thumbnail
        return false unless thumbnailable?
        transform_datastream :content, { thumbnail: { size: "100x100>", datastream: "thumbnail" } }
        thumbnail_changed?
      end

      def generate_thumbnail!
        generate_thumbnail && save
      end

      def virus_checks
        Ddr::Events::VirusCheckEvent.for_object(self)
      end

      def content_changed?
        content.external? ? content.dsLocation_changed? : content.content_changed?
      end

      def content_control_group
        content.controlGroup
      end

      def last_virus_check_on
        virus_checks.last.event_date_time_s rescue nil
      end

      def last_virus_check_outcome
        virus_checks.last.outcome rescue nil
      end

      protected
    
      def update_thumbnail
        yield
        if thumbnailable?
          generate_thumbnail!
        else
          thumbnail.delete
        end
      end

      def thumbnailable?
        has_content? && (image? || pdf?)
      end

      def default_content_type
        "application/octet-stream"
      end

    end
  end
end
