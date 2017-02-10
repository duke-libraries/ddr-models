module Ddr
  module Models
    module HasContent
      extend ActiveSupport::Concern

      included do
        has_file_datastream \
          name: Ddr::Datastreams::CONTENT,
          type: Ddr::Datastreams::ContentDatastream,
          versionable: true,
          label: "Content file for this object",
          control_group: "E"

        has_file_datastream \
          name: Ddr::Datastreams::EXTRACTED_TEXT,
          type: Ddr::Datastreams::PlainTextDatastream,
          versionable: true,
          label: "Text extracted from the content file",
          control_group: "M"

        has_metadata \
          name: Ddr::Datastreams::FITS,
          type: Ddr::Datastreams::FitsDatastream,
          versionable: false,
          label: "FITS Output for content file",
          control_group: "M"

        has_attributes :original_filename, datastream: "adminMetadata", multiple: false

        include FileManagement

        # after_add_file do
        #   if file_to_add.original_name && file_to_add.dsid == "content"
        #     self.original_filename = file_to_add.original_name
        #   end
        # end

        delegate :validate_checksum!, to: :content
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

      def derivatives
        @derivatives ||= Ddr::Managers::DerivativesManager.new(self)
      end

      def techmd
        @techmd ||= Ddr::Managers::TechnicalMetadataManager.new(self)
      end

      def content_size
        content.external? ? content.file_size : content.dsSize
      end

      def content_human_size
        ActiveSupport::NumberHelper.number_to_human_size(content_size) if content_size
      end

      def content_type
        content.mimeType
      end

      def content_major_type
        content_type.split("/").first
      end

      def content_sub_type
        content_type.split("/").last
      end

      def content_type= mime_type
        self.content.mimeType = mime_type
      end

      def image?
        content_major_type == "image"
      end

      def pdf?
        content_type == "application/pdf"
      end

      def virus_checks
        Ddr::Events::VirusCheckEvent.for_object(self)
      end

      def last_virus_check
        virus_checks.last
      end

      def last_virus_check_on
        last_virus_check && last_virus_check.event_date_time
      end

      def last_virus_check_outcome
        last_virus_check && last_virus_check.outcome
      end

      def content_changed?
        content.external? ? content.dsLocation_changed? : content.content_changed?
      end

      def has_extracted_text?
        extractedText.has_content?
      end

      def with_content_file(&block)
        WithContentFile.new(self, &block)
      end

      protected

      def default_content_type
        "application/octet-stream"
      end

    end
  end
end
