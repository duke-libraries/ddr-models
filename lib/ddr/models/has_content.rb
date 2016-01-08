module Ddr
  module Models
    module HasContent
      extend ActiveSupport::Concern
      extend Deprecation

      included do
        contains Ddr::Datastreams::CONTENT
        contains Ddr::Datastreams::EXTRACTED_TEXT, class_name: 'Ddr::Datastreams::PlainTextDatastream'
        contains Ddr::Datastreams::FITS, class_name: 'Ddr::Datastreams::FitsDatastream'

        property :legacy_original_filename,
                 predicate: RDF::Vocab::PREMIS.hasOriginalName,
                 multiple: false

        include FileManagement

        around_save :update_derivatives, if: :content_changed?

        around_save :characterize_file, if: [ :content_changed?, "Ddr::Models.characterize_files?" ]

        delegate :validate_checksum!, to: :content
      end

      # Convenience method wrapping FileManagement#add_file
      def upload(file, opts={})
        add_file(file, opts.merge(path: Ddr::Datastreams::CONTENT))
      end

      # Set content to file and save
      def upload!(file, opts={})
        upload(file, opts)
        save
      end

      def original_filename
        content.original_name
      end

      def original_filename=(filename)
        content.original_name = filename
      end

      def derivatives
        @derivatives ||= Ddr::Managers::DerivativesManager.new(self)
      end

      def techmd
        @techmd ||= Ddr::Managers::TechnicalMetadataManager.new(self)
      end

      def content_size
        content.size
      end

      def content_human_size
        ActiveSupport::NumberHelper.number_to_human_size(content_size) if content_size
      end

      def content_type
        content.mime_type
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
        content.content_changed?
      end

      def has_extracted_text?
        !extractedText.empty?
      end

      def with_content_file(&block)
        WithContentFile.new(self, &block)
      end

      protected

      def update_derivatives
        yield
        derivatives.update_derivatives(:later)
      end

      def characterize_file
        yield
        Resque.enqueue(Ddr::Jobs::FitsFileCharacterization, pid)
      end

      def default_content_type
        "application/octet-stream"
      end

    end
  end
end
