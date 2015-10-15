module Ddr
  module Models
    module Indexing

      include Ddr::Index::Fields

      def to_solr(solr_doc=Hash.new, opts={})
        solr_doc = super(solr_doc, opts)
        solr_doc.merge index_fields
      end

      def index_fields
        fields = {
          ACCESS_ROLE           => roles.to_json,
          ADMIN_SET             => admin_set,
          BOX_NUMBER_FACET      => desc_metadata_values('box_number'),
          CREATOR_FACET         => descMetadata.creator,
          DATE_FACET            => descMetadata.date,
          DATE_SORT             => date_sort,
          DEPOSITOR             => depositor,
          DISPLAY_FORMAT        => display_format,
          DOI                   => doi,
          EAD_ID                => ead_id,
          IDENTIFIER_ALL        => all_identifiers,
          LICENSE               => license,
          LOCAL_ID              => local_id,
          PERMANENT_ID          => permanent_id,
          PERMANENT_URL         => permanent_url,
          POLICY_ROLE           => roles.in_policy_scope.agents,
          PUBLISHER_FACET       => descMetadata.publisher,
          RESEARCH_HELP_CONTACT => research_help_contact,
          RESOURCE_ROLE         => roles.in_resource_scope.agents,
          SERIES_FACET          => desc_metadata_values('series'),
          SPATIAL_FACET         => desc_metadata_values('spatial'),
          TITLE                 => title_display,
          TYPE_FACET            => descMetadata.type,
          WORKFLOW_STATE        => workflow_state,
          YEAR_FACET            => year_facet,
        }
        if respond_to? :fixity_checks
          last_fixity_check = fixity_checks.last
          fields.merge!(last_fixity_check.to_solr) if last_fixity_check
        end
        if respond_to? :virus_checks
          last_virus_check = virus_checks.last
          fields.merge!(last_virus_check.to_solr) if last_virus_check
        end
        if has_content?
          fields[CONTENT_SIZE] = content_size
          fields[CONTENT_SIZE_HUMAN] = content_human_size
          fields[MEDIA_TYPE] = content_type
          fields[MEDIA_MAJOR_TYPE] = content_major_type
          fields[MEDIA_SUB_TYPE] = content_sub_type
          fields.merge! techmd.index_fields
        end
        if has_multires_image?
          fields[MULTIRES_IMAGE_FILE_PATH] = multires_image_file_path
        end
        if has_struct_metadata?
          fields[STRUCT_MAPS] = structure.struct_maps.to_json
        end
        if has_extracted_text?
          fields[EXTRACTED_TEXT] = extractedText.content
        end
        if is_a? Component
          fields[COLLECTION_URI] = collection_id
        end
        if is_a? Collection
          fields[ADMIN_SET_FACET] = admin_set_facet
          fields[COLLECTION_FACET] = collection_facet
        end
        if is_a? Item
          fields[ADMIN_SET_FACET] = admin_set_facet
          fields[COLLECTION_FACET] = collection_facet
        end
        fields
      end

      def title_display
        return descMetadata.title.first if descMetadata.title.present?
        return descMetadata.identifier.first if descMetadata.identifier.present?
        return original_filename if respond_to?(:original_filename) && original_filename.present?
        "[#{pid}]"
      end

      def all_identifiers
        descMetadata.identifier + [local_id, permanent_id, pid].compact
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
        associated_collection.id if associated_collection.present?
      end

      def date_sort
        descMetadata.date.first
      end

      def year_facet
        YearFacet.call(self)
      end

    end
  end
end
