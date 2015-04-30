module Ddr
  module IndexFields

    def self.solr_name(*args)
      ActiveFedora::SolrService.solr_name(*args)
    end

    ACCESS_ROLE                 = solr_name :access_role, :stored_sortable
    ACTIVE_FEDORA_MODEL         = solr_name :active_fedora_model, :stored_sortable
    COLLECTION_URI              = solr_name :collection_uri, :symbol
    CONTENT_CONTROL_GROUP       = solr_name :content_control_group, :searchable, type: :string
    CONTENT_SIZE                = solr_name :content_size, :stored_sortable, type: :integer
    CONTENT_SIZE_HUMAN          = solr_name :content_size_human, :symbol
    DEFAULT_LICENSE_DESCRIPTION = solr_name :default_license_description, type: :string
    DEFAULT_LICENSE_TITLE       = solr_name :default_license_title, type: :string
    DEFAULT_LICENSE_URL         = solr_name :default_license_url, type: :string
    EXTRACTED_TEXT              = solr_name :extracted_text, :searchable, type: :text
    FILE_GROUP                  = solr_name :struct_metadata__file_group, :stored_sortable
    FILE_USE                    = solr_name :struct_metadata__file_use, :stored_sortable
    HAS_MODEL                   = solr_name :has_model, :symbol
    IDENTIFIER                  = solr_name :identifier, :stored_sortable
    INTERNAL_URI                = solr_name :internal_uri, :stored_sortable
    IS_ATTACHED_TO              = solr_name :is_attached_to, :symbol
    IS_EXTERNAL_TARGET_FOR      = solr_name :is_external_target_for, :symbol
    IS_GOVERNED_BY              = solr_name :is_governed_by, :symbol
    IS_MEMBER_OF                = solr_name :is_member_of, :symbol
    IS_MEMBER_OF_COLLECTION     = solr_name :is_member_of_collection, :symbol
    IS_PART_OF                  = solr_name :is_part_of, :symbol
    LAST_FIXITY_CHECK_ON        = solr_name :last_fixity_check_on, :stored_sortable, type: :date
    LAST_FIXITY_CHECK_OUTCOME   = solr_name :last_fixity_check_outcome, :symbol
    LAST_VIRUS_CHECK_ON         = solr_name :last_virus_check_on, :stored_sortable, type: :date
    LAST_VIRUS_CHECK_OUTCOME    = solr_name :last_virus_check_outcome, :symbol
    LICENSE_DESCRIPTION         = solr_name :license_description, type: :string
    LICENSE_TITLE               = solr_name :license_title, type: :string
    LICENSE_URL                 = solr_name :license_url, type: :string
    LOCAL_ID                    = solr_name :local_id, :stored_sortable
    MEDIA_SUB_TYPE              = solr_name :content_media_sub_type, :facetable
    MEDIA_MAJOR_TYPE            = solr_name :content_media_major_type, :facetable
    MEDIA_TYPE                  = solr_name :content_media_type, :symbol
    MULTIRES_IMAGE_FILE_PATH    = solr_name :multires_image_file_path, :stored_sortable
    OBJECT_PROFILE              = solr_name :object_profile, :displayable
    OBJECT_STATE                = solr_name :object_state, :stored_sortable
    OBJECT_CREATE_DATE          = solr_name :system_create, :stored_sortable, type: :date
    OBJECT_MODIFIED_DATE        = solr_name :system_modified, :stored_sortable, type: :date
    ORDER                       = solr_name :struct_metadata__order, :stored_sortable, type: :integer
    PERMANENT_ID                = solr_name :permanent_id, :stored_sortable, type: :string
    PERMANENT_URL               = solr_name :permanent_url, :stored_sortable, type: :string
    POLICY_ROLE                 = solr_name :policy_role, :facetable, type: :string
    RESOURCE_ROLE               = solr_name :resource_role, :facetable, type: :string
    TITLE                       = solr_name :title, :stored_sortable
    WORKFLOW_STATE              = solr_name :workflow_state, :stored_sortable

  end
end
