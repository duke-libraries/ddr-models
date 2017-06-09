require 'time'

module Ddr::Models
  module Indexing

    include Ddr::Index::Fields

    def self.const_missing(name)
      Ddr::Index::Fields.const_missing(name)
    end

    def to_solr(solr_doc=Hash.new, opts={})
      solr_doc = super(solr_doc, opts)
      solr_doc.merge index_fields
    end

    def index_fields
      fields = {
        ACCESS_ROLE             => roles.to_json,
        ADMIN_SET               => admin_set,
        ADMIN_SET_TITLE         => admin_set_title,
        AFFILIATION             => affiliation,
        AFFILIATION_FACET       => affiliation,
        ALEPH_ID                => aleph_id,
        ARRANGER_FACET          => desc_metadata_values('arranger'),
        ASPACE_ID               => aspace_id,
        ATTACHED_FILES_HAVING_CONTENT => attached_files_having_content.keys,
        BOX_NUMBER_FACET        => desc_metadata_values('box_number'),
        CATEGORY_FACET          => desc_metadata_values('category'),
        COLLECTION_TITLE        => collection_title,
        COMPANY_FACET           => desc_metadata_values('company'),
        COMPOSER_FACET          => desc_metadata_values('composer'),
        CONTRIBUTOR_FACET       => contributor,
        CREATOR_FACET           => creator,
        DATE_FACET              => date,
        DATE_SORT               => date_sort,
        DC_IS_PART_OF           => desc_metadata_values('isPartOf'),
        DEPOSITOR               => depositor,
        DISPLAY_FORMAT          => display_format,
        DOI                     => adminMetadata.doi,
        EAD_ID                  => ead_id,
        ENGRAVER_FACET          => desc_metadata_values('engraver'),
        FOLDER_FACET            => desc_metadata_values('folder'),
        FORMAT_FACET            => format,
        GENRE_FACET             => desc_metadata_values('genre'),
        IDENTIFIER_ALL          => all_identifiers,
        ILLUSTRATED_FACET       => desc_metadata_values('illustrated'),
        ILLUSTRATOR_FACET       => desc_metadata_values('illustrator'),
        INGESTED_BY             => ingested_by,
        INGESTION_DATE          => ingestion_date,
        INSTRUMENTATION_FACET   => desc_metadata_values('instrumentation'),
        INTERNAL_URI            => internal_uri,
        INTERVIEWER_NAME_FACET  => desc_metadata_values('interviewer_name'),
        IS_FORMAT_OF            => desc_metadata_values('isFormatOf'),
        IS_LOCKED               => is_locked,
        LANGUAGE_FACET          => language_name,
        LANGUAGE_NAME           => language_name,
        LICENSE                 => license,
        LITHOGRAPHER_FACET      => desc_metadata_values('lithographer'),
        LOCAL_ID                => local_id,
        LYRICIST_FACET          => desc_metadata_values('lyricist'),
        MEDIUM_FACET            => desc_metadata_values('medium'),
        PERFORMER_FACET         => desc_metadata_values('performer'),
        PERMANENT_ID            => permanent_id,
        PERMANENT_URL           => permanent_url,
        PLACEMENT_COMPANY_FACET => desc_metadata_values('placement_company'),
        POLICY_ROLE             => roles.in_policy_scope.agents,
        PRODUCER_FACET          => desc_metadata_values('producer'),
        PRODUCT_FACET           => desc_metadata_values('product'),
        PUBLICATION_FACET       => desc_metadata_values('publication'),
        PUBLISHER_FACET         => publisher,
        RESEARCH_HELP_CONTACT   => research_help_contact,
        RESOURCE_ROLE           => roles.in_resource_scope.agents,
        RIGHTS_NOTE             => rights_note,
        ROLL_NUMBER_FACET       => desc_metadata_values('roll_number'),
        SERIES_FACET            => desc_metadata_values('series'),
        SETTING_FACET           => desc_metadata_values('setting'),
        SPATIAL_FACET           => desc_metadata_values('spatial'),
        SUBJECT_FACET           => subject,
        SUBSERIES_FACET         => desc_metadata_values('subseries'),
        TEMPORAL_FACET          => desc_metadata_values('temporal'),
        TITLE                   => title_display,
        TONE_FACET              => desc_metadata_values('tone'),
        TYPE_FACET              => type,
        VOLUME_FACET            => desc_metadata_values('volume'),
        WORKFLOW_STATE          => workflow_state,
        YEAR_FACET              => year_facet,
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
        fields[CONTENT_CREATE_DATE] = Ddr::Utils.solr_date(content.createDate)
        fields[CONTENT_CONTROL_GROUP] = content.controlGroup
        fields[CONTENT_SIZE] = content_size
        fields[CONTENT_SIZE_HUMAN] = content_human_size
        fields[MEDIA_TYPE] = content_type
        fields[MEDIA_MAJOR_TYPE] = content_major_type
        fields[MEDIA_SUB_TYPE] = content_sub_type
        fields[ORIGINAL_DIRNAME] = original_dirname
        fields.merge! techmd.index_fields
      end
      if has_multires_image?
        fields[MULTIRES_IMAGE_FILE_PATH] = multires_image_file_path
      end
      if has_struct_metadata?
        fields[STRUCTURE] = structure.dereferenced_structure.to_json
        fields[STRUCTURE_SOURCE] = structure.repository_maintained? ? Ddr::Models::Structure::REPOSITORY_MAINTAINED
                                                                    : Ddr::Models::Structure::EXTERNALLY_PROVIDED
      end
      if has_extracted_text?
        fields[EXTRACTED_TEXT] = extractedText.content
      end
      if streamable?
        fields[STREAMABLE_MEDIA_TYPE] = streamable_media_type
      end
      if is_a? Component
        fields[COLLECTION_URI] = collection_uri
      end
      if is_a? Collection
        fields[ADMIN_SET_FACET] = admin_set_facet
        fields[COLLECTION_FACET] = collection_facet
      end
      if is_a? Item
        fields[ADMIN_SET_FACET] = admin_set_facet
        fields[COLLECTION_FACET] = collection_facet
        fields[NESTED_PATH] = nested_path
        fields[ALL_TEXT] = all_text
      end
      fields
    end

    def title_display
      return title.first if title.present?
      return identifier.first if identifier.present?
      return original_filename if respond_to?(:original_filename) && original_filename.present?
      "[#{pid}]"
    end

    def all_identifiers
      identifier + [local_id, permanent_id, pid].compact
    end

    def associated_collection
      # XXX Can/should we use SolrDocument here?
      # I.e., ::SolrDocument.find(admin_policy_id)
      admin_policy
    end

    def admin_set_facet
      if admin_set.present?
        admin_set
      elsif associated_collection.present?
        associated_collection.admin_set
      end
    end

    def admin_set_title
      code = if admin_set.present?
               admin_set
             elsif associated_collection.present?
               associated_collection.admin_set
             else
               nil
             end
      if code && ( as = AdminSet.find_by_code(code) )
        as.title
      end
    end

    def collection_facet
      associated_collection.internal_uri if associated_collection.present?
    end

    def collection_title
      if instance_of?(Collection)
        title_display
      elsif associated_collection.present?
        associated_collection.title_display
      end
    end

    def date_sort
      date.first
    end

    def language_name
      language.map do |lang|
        Language.find_by_code(lang).to_s rescue lang
      end
    end

    def year_facet
      YearFacet.call(self)
    end

  end
end
