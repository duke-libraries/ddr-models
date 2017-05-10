module Ddr::Index
  module Fields
    extend Deprecation

    ID = UniqueKeyField.instance

    ACCESS_ROLE                 = Field.new :access_role, :stored_sortable
    ACTIVE_FEDORA_MODEL         = Field.new :active_fedora_model, :stored_sortable
    ADMIN_SET                   = Field.new :admin_set, :stored_sortable
    ADMIN_SET_FACET             = Field.new :admin_set_facet, :facetable
    ADMIN_SET_TITLE             = Field.new :admin_set_title, :stored_sortable
    ALEPH_ID                    = Field.new :aleph_id, :stored_sortable
    ALL_TEXT                    = Field.new :all_text, solr_name: "all_text_timv"
    ARRANGER_FACET              = Field.new :arranger_facet, :facetable
    ASPACE_ID                   = Field.new :aspace_id, :stored_sortable
    ATTACHED_FILES_HAVING_CONTENT =
      Field.new :attached_files_having_content, :symbol
    BOX_NUMBER_FACET            = Field.new :box_number_facet, :facetable
    CATEGORY_FACET              = Field.new :category_facet, :facetable
    COLLECTION_FACET            = Field.new :collection_facet, :facetable
    COLLECTION_TITLE            = Field.new :collection_title, :stored_sortable
    COLLECTION_URI              = Field.new :collection_uri, :symbol
    COMPANY_FACET               = Field.new :company_facet, :facetable
    COMPOSER_FACET              = Field.new :composer_facet, :facetable
    CONTENT_CONTROL_GROUP       = Field.new :content_control_group, :searchable, type: :string
    CONTENT_CREATE_DATE         = Field.new :content_create_date, :stored_sortable, type: :date
    CONTENT_SIZE                = Field.new :content_size, solr_name: "content_size_lsi"
    CONTENT_SIZE_HUMAN          = Field.new :content_size_human, :symbol
    CONTRIBUTOR_FACET           = Field.new :contributor_facet, :facetable
    CREATOR_FACET               = Field.new :creator_facet, :facetable
    DATE_FACET                  = Field.new :date_facet, :facetable
    DATE_SORT                   = Field.new :date_sort, :sortable
    DC_IS_PART_OF               = Field.new :isPartOf, :symbol
    DEPOSITOR                   = Field.new :depositor, :stored_sortable
    DISPLAY_FORMAT              = Field.new :display_format, :stored_sortable
    DOI                         = Field.new :doi, :symbol
    EAD_ID                      = Field.new :ead_id, :stored_sortable
    ENGRAVER_FACET              = Field.new :engraver_facet, :facetable
    EXTRACTED_TEXT              = Field.new :extracted_text, solr_name: "extracted_text_tsm"
    FOLDER_FACET                = Field.new :folder_facet, :facetable
    FORMAT_FACET                = Field.new :format_facet, :facetable
    GENRE_FACET                 = Field.new :genre_facet, :facetable
    HAS_MODEL                   = Field.new :has_model, :symbol
    IDENTIFIER_ALL              = Field.new :identifier_all, :symbol
    ILLUSTRATED_FACET           = Field.new :illustrated_facet, :facetable
    ILLUSTRATOR_FACET           = Field.new :illustrator_facet, :facetable
    INGESTED_BY                 = Field.new :ingested_by, :stored_sortable
    INGESTION_DATE              = Field.new :ingestion_date, :stored_sortable, type: :date
    INSTRUMENTATION_FACET       = Field.new :instrumentation_facet, :facetable
    INTERNAL_URI                = Field.new :internal_uri, :stored_sortable
    INTERVIEWER_NAME_FACET      = Field.new :interviewer_name_facet, :facetable
    IS_ATTACHED_TO              = Field.new :is_attached_to, :symbol
    IS_EXTERNAL_TARGET_FOR      = Field.new :is_external_target_for, :symbol
    IS_FORMAT_OF                = Field.new :isFormatOf, :symbol
    IS_GOVERNED_BY              = Field.new :is_governed_by, :symbol
    IS_LOCKED                   = Field.new :is_locked, :stored_sortable
    IS_MEMBER_OF                = Field.new :is_member_of, :symbol
    IS_MEMBER_OF_COLLECTION     = Field.new :is_member_of_collection, :symbol
    IS_PART_OF                  = Field.new :is_part_of, :symbol
    LAST_FIXITY_CHECK_ON        = Field.new :last_fixity_check_on, :stored_sortable, type: :date
    LAST_FIXITY_CHECK_OUTCOME   = Field.new :last_fixity_check_outcome, :symbol
    LAST_VIRUS_CHECK_ON         = Field.new :last_virus_check_on, :stored_sortable, type: :date
    LAST_VIRUS_CHECK_OUTCOME    = Field.new :last_virus_check_outcome, :symbol
    LICENSE                     = Field.new :license, :stored_sortable
    LITHOGRAPHER_FACET          = Field.new :lithographer_facet, :facetable
    LOCAL_ID                    = Field.new :local_id, :stored_sortable
    LYRICIST_FACET              = Field.new :lyricist_facet, :facetable
    MEDIA_SUB_TYPE              = Field.new :content_media_sub_type, :facetable
    MEDIA_MAJOR_TYPE            = Field.new :content_media_major_type, :facetable
    MEDIA_TYPE                  = Field.new :content_media_type, :symbol
    MEDIUM_FACET                = Field.new :medium_facet, :facetable
    MULTIRES_IMAGE_FILE_PATH    = Field.new :multires_image_file_path, :stored_sortable
    OBJECT_PROFILE              = Field.new :object_profile, :displayable
    OBJECT_STATE                = Field.new :object_state, :stored_sortable
    OBJECT_CREATE_DATE          = Field.new :system_create, :stored_sortable, type: :date
    OBJECT_MODIFIED_DATE        = Field.new :system_modified, :stored_sortable, type: :date
    PERFORMER_FACET             = Field.new :performer_facet, :facetable
    PERMANENT_ID                = Field.new :permanent_id, :stored_sortable, type: :string
    PERMANENT_URL               = Field.new :permanent_url, :stored_sortable, type: :string
    PLACEMENT_COMPANY_FACET     = Field.new :placement_company_facet, :facetable
    POLICY_ROLE                 = Field.new :policy_role, :symbol
    PRODUCER_FACET              = Field.new :producer_facet, :facetable
    PRODUCT_FACET               = Field.new :product_facet, :facetable
    PUBLICATION_FACET           = Field.new :publication_facet, :facetable
    PUBLISHER_FACET             = Field.new :publisher_facet, :facetable
    RESEARCH_HELP_CONTACT       = Field.new :research_help_contact, :stored_sortable
    RESOURCE_ROLE               = Field.new :resource_role, :symbol
    RIGHTS_NOTE                 = Field.new :rights_note, :stored_searchable
    ROLL_NUMBER_FACET           = Field.new :roll_number_facet, :facetable
    SERIES_FACET                = Field.new :series_facet, :facetable
    SETTING_FACET               = Field.new :setting_facet, :facetable
    SPATIAL_FACET               = Field.new :spatial_facet, :facetable
    STREAMABLE_MEDIA_TYPE       = Field.new :streamable_media_type, :stored_sortable
    STRUCTURE                   = Field.new :structure, solr_name: "structure_ss"
    STRUCTURE_SOURCE            = Field.new :structure_source, :stored_sortable
    SUBJECT_FACET               = Field.new :subject_facet, :facetable
    SUBSERIES_FACET             = Field.new :subseries_facet, :facetable
    TECHMD_COLOR_SPACE          = Field.new :techmd_color_space, :symbol
    TECHMD_CREATING_APPLICATION = Field.new :techmd_creating_application, :symbol
    TECHMD_CREATION_TIME        = Field.new :techmd_creation_time, :stored_searchable, type: :date
    TECHMD_FILE_SIZE            = Field.new :techmd_file_size, solr_name: "techmd_file_size_lsi"
    TECHMD_FITS_VERSION         = Field.new :techmd_fits_version, :stored_sortable
    TECHMD_FITS_DATETIME        = Field.new :techmd_fits_datetime, :stored_sortable, type: :date
    TECHMD_FORMAT_LABEL         = Field.new :techmd_format_label, :symbol
    TECHMD_FORMAT_VERSION       = Field.new :techmd_format_version, :symbol
    TECHMD_ICC_PROFILE_NAME     = Field.new :techmd_icc_profile_name, :symbol
    TECHMD_ICC_PROFILE_VERSION  = Field.new :techmd_icc_profile_version, :symbol
    TECHMD_IMAGE_HEIGHT         = Field.new :techmd_image_height, :stored_searchable, type: :integer
    TECHMD_IMAGE_WIDTH          = Field.new :techmd_image_width, :stored_searchable, type: :integer
    TECHMD_MD5                  = Field.new :techmd_md5, :stored_sortable
    TECHMD_MEDIA_TYPE           = Field.new :techmd_media_type, :symbol
    TECHMD_MODIFICATION_TIME    = Field.new :techmd_modification_time, :stored_searchable, type: :date
    TECHMD_PRONOM_IDENTIFIER    = Field.new :techmd_pronom_identifier, :symbol
    TECHMD_VALID                = Field.new :techmd_valid, :symbol
    TECHMD_WELL_FORMED          = Field.new :techmd_well_formed, :symbol
    TEMPORAL_FACET              = Field.new :temporal_facet, :facetable
    TITLE                       = Field.new :title, :stored_sortable
    TONE_FACET                  = Field.new :tone_facet, :facetable
    TYPE_FACET                  = Field.new :type_facet, :facetable
    VOLUME_FACET                = Field.new :volume_facet, :facetable
    WORKFLOW_STATE              = Field.new :workflow_state, :stored_sortable
    YEAR_FACET                  = Field.new :year_facet, solr_name: "year_facet_iim"

    def self.get(name)
      const_get(name.to_s.upcase, false)
    end

    def self.techmd
      @techmd ||= constants(false).select { |c| c =~ /\ATECHMD_/ }.map { |c| const_get(c) }.freeze
    end

    def self.descmd
      @descmd ||= Ddr::Datastreams::DescriptiveMetadataDatastream.properties.map do |base, config|
        Field.new base, *(config.behaviors)
      end.freeze
    end

    def self.const_missing(name)
      if name == :PID
        Deprecation.warn(Ddr::Index::Fields,
                         "`Ddr::Index::Fields::#{name}` is deprecated." \
                         " Use `Ddr::Index::Fields::ID` instead.")
        ID
      else
        super
      end
    end

  end
end
