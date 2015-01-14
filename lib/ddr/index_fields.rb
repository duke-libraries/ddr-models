module Ddr
  module IndexFields

    def self.solr_name(*args)
      ActiveFedora::SolrService.solr_name(*args)
    end

    def self.relationship_field(rel)
      solr_name(rel, :symbol)
    end

    def self.relationship?(name)
      ActiveFedora::Predicates.find_graph_predicate(name) && true
    rescue ActiveFedora::UnregisteredPredicateError
      false
    end

    def self.defined_attribute_field(attr)
      Ddr::Models::Base.defined_attributes[attr].primary_solr_name
    end

    def self.defined_attribute?(attr)
      Ddr::Models::Base.defined_attributes.include?(attr)
    end

    def self.object_profile
      Ddr::Models::Base.profile_solr_name
    end

    def self.method_missing(name, *args)
      if args.size == 0
        return defined_attribute_field(name) if defined_attribute?(name)
        return relationship_field(name) if relationship?(name)
        case name
        when :active_fedora_model, :object_state
          return solr_name(name, :stored_sortable)
        when :system_create, :system_modified
          return solr_name(name, :stored_sortable, type: :date)
        end
      end
      super
    end

    # @deprecated Use `Ddr::IndexFields.object_profile`.
    OBJECT_PROFILE            = object_profile

    # @deprecated Use `Ddr::IndexFields.active_fedora_model`.
    ACTIVE_FEDORA_MODEL       = active_fedora_model
    # @deprecated Use `Ddr::IndexFields.object_state`.
    OBJECT_STATE              = object_state
    # @deprecated Use `Ddr::IndexFields.system_create`.
    OBJECT_CREATE_DATE        = system_create
    # @deprecated Use `Ddr::IndexFields.system_modified`.
    OBJECT_MODIFIED_DATE      = system_modified

    # @deprecated Use `Ddr::IndexFields.has_model`.
    HAS_MODEL                 = has_model
    # @deprecated Use `Ddr::IndexFields.is_attached_to`.
    IS_ATTACHED_TO            = is_attached_to
    # @deprecated Use `Ddr::IndexFields.is_external_target_for`.
    IS_EXTERNAL_TARGET_FOR    = is_external_target_for
    # @deprecated Use `Ddr::IndexFields.is_governed_by`.
    IS_GOVERNED_BY            = is_governed_by
    # @deprecated Use `Ddr::IndexFields.is_member_of`.
    IS_MEMBER_OF              = is_member_of
    # @deprecated Use `Ddr::IndexFields.is_member_of_collection`.
    IS_MEMBER_OF_COLLECTION   = is_member_of_collection
    # @deprecated Use `Ddr::IndexFields.is_part_of`.
    IS_PART_OF                = is_part_of

    # @deprecated Use `Component.index_name(:collection_uri)`
    COLLECTION_URI            = ::Component.index_name(:collection_uri)
    # @deprecated Use `Component.index_name(:content_control_group)`
    CONTENT_CONTROL_GROUP     = ::Component.index_name(:content_control_group)

    # @deprecated Use `Item.index_name(:content_metadata_parsed)`
    CONTENT_METADATA_PARSED   = ::Item.index_name(:content_metadata_parsed)

    # @deprecated Use `Component.index_name(:content_size)`
    CONTENT_SIZE              = ::Component.index_name(:content_size)
    # @deprecated Use `Component.index_name(:content_size_human)`
    CONTENT_SIZE_HUMAN        = ::Component.index_name(:content_size_human)

    # @deprecated Use `Ddr::Models::Base.index_name(:identifier_sort)`
    IDENTIFIER                = Ddr::Models::Base.index_name(:identifier)
    # @deprecated Use `Ddr::Models::Base.index_name(:internal_uri)`
    INTERNAL_URI              = Ddr::Models::Base.index_name(:internal_uri)
    # @deprecated Use `Ddr::Models::Base.index_name(:last_fixity_check_on)`
    LAST_FIXITY_CHECK_ON      = Ddr::Models::Base.index_name(:last_fixity_check_on)
    # @deprecated Use `Ddr::Models::Base.index_name(:last_fixity_check_outcome)`
    LAST_FIXITY_CHECK_OUTCOME = Ddr::Models::Base.index_name(:last_fixity_check_outcome)

    # @deprecated Use `Component.index_name(:last_virus_check_on)`
    LAST_VIRUS_CHECK_ON       = ::Component.index_name(:last_virus_check_on)
    # @deprecated Use `Component.index_name(:last_virus_check_outcome)`
    LAST_VIRUS_CHECK_OUTCOME  = ::Component.index_name(:last_virus_check_outcome)

    # @deprecated Use `Component.index_name(:content_media_sub_type)`
    MEDIA_SUB_TYPE            = ::Component.index_name(:content_media_sub_type)
    # @deprecated Use `Component.index_name(:content_media_major_type)`
    MEDIA_MAJOR_TYPE          = ::Component.index_name(:content_media_major_type)
    # @deprecated Use `Component.index_name(:content_media_type)`
    MEDIA_TYPE                = ::Component.index_name(:content_media_type)

    # @deprecated Use `Ddr::Models::Base.index_name(:title_display)`
    TITLE                     = Ddr::Models::Base.index_name(:title)

    # @deprecated Use `Ddr::IndexFields.permanent_id`.
    PERMANENT_ID              = permanent_id
    # @deprecated Use `Ddr::IndexFields.permanent_url`.
    PERMANENT_URL             = permanent_url
    # @deprecated Use `Ddr::IndexFields.workflow_state`.
    WORKFLOW_STATE            = workflow_state 

  end
end
