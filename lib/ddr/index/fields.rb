module Ddr::Index
  module Fields

    def self.get(name)
      const_get(name.to_s.upcase, false)
    end

    ID = UniqueKeyField.instance
    PID = UniqueKeyField.instance

    ACCESS_ROLE                 = Field.new :access_role, :stored_sortable
    ACTIVE_FEDORA_MODEL         = Field.new :active_fedora_model, :stored_sortable
    ADMIN_SET                   = Field.new :admin_set, :stored_sortable
    ADMIN_SET_FACET             = Field.new :admin_set_facet, :facetable
    COLLECTION_FACET            = Field.new :collection_facet, :facetable
    COLLECTION_URI              = Field.new :collection_uri, :symbol
    CONTENT_CONTROL_GROUP       = Field.new :content_control_group, :searchable, type: :string
    CONTENT_SIZE                = Field.new :content_size, :stored_sortable, type: :integer
    CONTENT_SIZE_HUMAN          = Field.new :content_size_human, :symbol
    CREATOR_FACET               = Field.new :creator_facet, :facetable
    DATE_FACET                  = Field.new :date_facet, :facetable
    DATE_SORT                   = Field.new :date_sort, :sortable
    DEFAULT_LICENSE_DESCRIPTION = Field.new :default_license_description, type: :string
    DEFAULT_LICENSE_TITLE       = Field.new :default_license_title, type: :string
    DEFAULT_LICENSE_URL         = Field.new :default_license_url, type: :string
    DISPLAY_FORMAT              = Field.new :display_format, :stored_sortable
    EXTRACTED_TEXT              = Field.new :extracted_text, :searchable, type: :text
    HAS_MODEL                   = Field.new :has_model, :symbol
    IDENTIFIER_ALL              = Field.new :identifier_all, :symbol
    INTERNAL_URI                = Field.new :internal_uri, :stored_sortable
    IS_ATTACHED_TO              = Field.new :is_attached_to, :symbol
    IS_EXTERNAL_TARGET_FOR      = Field.new :is_external_target_for, :symbol
    IS_GOVERNED_BY              = Field.new :is_governed_by, :symbol
    IS_MEMBER_OF                = Field.new :is_member_of, :symbol
    IS_MEMBER_OF_COLLECTION     = Field.new :is_member_of_collection, :symbol
    IS_PART_OF                  = Field.new :is_part_of, :symbol
    LAST_FIXITY_CHECK_ON        = Field.new :last_fixity_check_on, :stored_sortable, type: :date
    LAST_FIXITY_CHECK_OUTCOME   = Field.new :last_fixity_check_outcome, :symbol
    LAST_VIRUS_CHECK_ON         = Field.new :last_virus_check_on, :stored_sortable, type: :date
    LAST_VIRUS_CHECK_OUTCOME    = Field.new :last_virus_check_outcome, :symbol
    LICENSE_DESCRIPTION         = Field.new :license_description, type: :string
    LICENSE_TITLE               = Field.new :license_title, type: :string
    LICENSE_URL                 = Field.new :license_url, type: :string
    LOCAL_ID                    = Field.new :local_id, :stored_sortable
    MEDIA_SUB_TYPE              = Field.new :content_media_sub_type, :facetable
    MEDIA_MAJOR_TYPE            = Field.new :content_media_major_type, :facetable
    MEDIA_TYPE                  = Field.new :content_media_type, :symbol
    MULTIRES_IMAGE_FILE_PATH    = Field.new :multires_image_file_path, :stored_sortable
    OBJECT_PROFILE              = Field.new :object_profile, :displayable
    OBJECT_STATE                = Field.new :object_state, :stored_sortable
    OBJECT_CREATE_DATE          = Field.new :system_create, :stored_sortable, type: :date
    OBJECT_MODIFIED_DATE        = Field.new :system_modified, :stored_sortable, type: :date
    PERMANENT_ID                = Field.new :permanent_id, :stored_sortable, type: :string
    PERMANENT_URL               = Field.new :permanent_url, :stored_sortable, type: :string
    POLICY_ROLE                 = Field.new :policy_role, :symbol
    RESEARCH_HELP_CONTACT       = Field.new :research_help_contact, :stored_sortable
    RESOURCE_ROLE               = Field.new :resource_role, :symbol
    STRUCT_MAPS                 = Field.new :struct_maps, :stored_sortable
    TECHMD_COLOR_SPACE          = Field.new :techmd_color_space, :symbol
    TECHMD_CREATING_APPLICATION = Field.new :techmd_creating_application, :symbol
    TECHMD_CREATION_TIME        = Field.new :techmd_creation_time, :stored_searchable, type: :date
    TECHMD_FILE_SIZE            = Field.new :techmd_file_size, :stored_searchable, type: :integer
    TECHMD_FITS_VERSION         = Field.new :techmd_fits_version, :stored_sortable
    TECHMD_FITS_DATETIME        = Field.new :techmd_fits_datetime, :stored_sortable, type: :date
    TECHMD_FORMAT_LABEL         = Field.new :techmd_format_label, :symbol
    TECHMD_FORMAT_VERSION       = Field.new :techmd_format_version, :symbol
    TECHMD_IMAGE_HEIGHT         = Field.new :techmd_image_height, :stored_searchable, type: :integer
    TECHMD_IMAGE_WIDTH          = Field.new :techmd_image_width, :stored_searchable, type: :integer
    TECHMD_MEDIA_TYPE           = Field.new :techmd_media_type, :symbol
    TECHMD_MODIFICATION_TIME    = Field.new :techmd_modification_time, :stored_searchable, type: :date
    TECHMD_PRONOM_IDENTIFIER    = Field.new :techmd_pronom_identifier, :symbol
    TECHMD_VALID                = Field.new :techmd_valid, :symbol
    TECHMD_WELL_FORMED          = Field.new :techmd_well_formed, :symbol
    TITLE                       = Field.new :title, :stored_sortable
    WORKFLOW_STATE              = Field.new :workflow_state, :stored_sortable
    YEAR_FACET                  = Field.new :year_facet, solr_name: "year_facet_iim"

  end
end