module Ddr
  module Models
    module Indexing

      include Ddr::IndexFields

      def to_solr(solr_doc=Hash.new, opts={})
        solr_doc = super(solr_doc, opts)
        solr_doc.merge index_fields
      end

      def index_fields
        fields = {
          TITLE             => title_display,
          INTERNAL_URI      => internal_uri,
          IDENTIFIER        => identifier_sort,
          WORKFLOW_STATE    => workflow_state,
          LOCAL_ID          => local_id,
          ADMIN_SET         => admin_set,
          PERMANENT_ID      => permanent_id,
          PERMANENT_URL     => permanent_url,
          CREATOR_FACET     => creator,
          DATE_FACET        => date,
          DATE_SORT         => date_sort
        }
        if respond_to? :fixity_checks
          last_fixity_check = fixity_checks.last
          fields.merge!(last_fixity_check.to_solr) if last_fixity_check
        end
        if respond_to? :virus_checks
          last_virus_check = virus_checks.last
          fields.merge!(last_virus_check.to_solr) if last_virus_check
        end
        if respond_to? :license
          fields[LICENSE_DESCRIPTION] = license_description
          fields[LICENSE_TITLE] = license_title
          fields[LICENSE_URL] = license_url
        end
        if has_content?
          fields[CONTENT_CONTROL_GROUP] = content.controlGroup
          fields[CONTENT_SIZE] = content_size
          fields[CONTENT_SIZE_HUMAN] = content_human_size
          fields[MEDIA_TYPE] = content_type
          fields[MEDIA_MAJOR_TYPE] = content_major_type
          fields[MEDIA_SUB_TYPE] = content_sub_type
        end
        if has_multires_image?
          fields[MULTIRES_IMAGE_FILE_PATH] = multires_image_file_path
        end
        if has_extracted_text?
          fields[EXTRACTED_TEXT] = extractedText.content
        end
        if is_a? Component
          fields[COLLECTION_URI] = collection_uri
        end
        if is_a? Collection
          fields[DEFAULT_LICENSE_DESCRIPTION] = default_license_description
          fields[DEFAULT_LICENSE_TITLE] = default_license_title
          fields[DEFAULT_LICENSE_URL] = default_license_url
          fields[ADMIN_SET_FACET] = admin_set_facet
          fields[COLLECTION_FACET] = collection_facet
        end
        if is_a? Item
          fields[ADMIN_SET_FACET] = admin_set_facet
          fields[COLLECTION_FACET] = collection_facet
        end
        if respond_to? :roles
          fields.merge!(roles.index_fields)
        end
        fields
      end

      def title_display
        return title.first if title.present?
        return identifier.first if identifier.present?
        return original_filename if respond_to?(:original_filename) && original_filename.present?
        "[#{pid}]"
      end

      def identifier_sort
        identifier.first
      end

      def associated_collection
        admin_policy
      end

      def admin_set_facet
        if admin_set.present?
          admin_set
        elsif associated_collection.present?
          associated_collection.admin_set
        end
      end

      def collection_facet
        associated_collection.internal_uri if associated_collection.present?
      end

      def date_sort
        date.first
      end

    end
  end
end
