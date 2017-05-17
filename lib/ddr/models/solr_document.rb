require 'json'

module Ddr::Models
  module SolrDocument
    extend ActiveSupport::Concern
    extend Deprecation

    self.deprecation_horizon = 'ddr-models v3.0'

    included do
      alias_method :pid, :id
    end

    class NotFound < Error; end

    module ClassMethods
      def find(pid_or_uri)
        query = Ddr::Index::Query.new { id pid_or_uri.sub(/\Ainfo:fedora\//, "") }
        if doc = query.docs.first
          return doc
        end
        raise NotFound, "SolrDocument not found for \"#{pid_or_uri}\"."
      end

      def find_by_permanent_id(ark)
        query = Ddr::Index::Query.new { where permanent_id: ark }
        if doc = query.docs.first
          return doc
        end
        raise NotFound, "SolrDocument not found for permanent id \"#{ark}\"."
      end
    end

    def inspect
      "#<#{self.class.name} id=#{id.inspect}>"
    end

    def method_missing(name, *args, &block)
      if args.empty? && !block
        begin
          field = Ddr::Index::Fields.get(name)
        rescue NameError
        # pass
        else
          # Preserves the default behavior of the deprecated method
          # Blacklight::Solr::Document#get, which this procedure
          # effectively replaces.
          val = self[field]
          return val.is_a?(Array) ? val.join(", ") : val
        end
      end
      super
    end

    def to_partial_path
      'document'
    end

    def safe_id
      id.sub(/:/, "-")
    end

    def object_profile
      @object_profile ||= get_json(Ddr::Index::Fields::OBJECT_PROFILE)
    end

    def object_state
      object_profile["objState"]
    end

    def object_create_date
      parse_date(object_profile["objCreateDate"])
    end

    def object_modified_date
      parse_date(object_profile["objLastModDate"])
    end

    def last_fixity_check_on
      get_date(Ddr::Index::Fields::LAST_FIXITY_CHECK_ON)
    end

    def last_virus_check_on
      get_date(Ddr::Index::Fields::LAST_VIRUS_CHECK_ON)
    end

    def datastreams
      object_profile["datastreams"]
    end

    def has_datastream?(dsID)
      datastreams[dsID].present?
    end

    def has_admin_policy?
      admin_policy_uri.present?
    end

    def admin_policy_uri
      is_governed_by
    end

    def admin_policy_pid
      uri = admin_policy_uri
      uri &&= ActiveFedora::Base.pid_from_uri(uri)
    end
    alias_method :admin_policy_id, :admin_policy_pid

    def admin_policy
      if has_admin_policy?
        self.class.find(admin_policy_uri)
      end
    end

    def has_children?
      ActiveFedora::SolrService.class_from_solr_document(self).reflect_on_association(:children).present?
    end

    def label
      object_profile["objLabel"]
    end

    def title_display
      title
    end

    def identifier
      # We want the multivalued version here
      self[ActiveFedora::SolrService.solr_name(:identifier, :stored_searchable, type: :text)]
    end

    def source
      self[ActiveFedora::SolrService.solr_name(:source, :stored_searchable, type: :text)]
    end

    def has_thumbnail?
      has_datastream?(Ddr::Datastreams::THUMBNAIL)
    end

    def has_content?
      has_datastream?(Ddr::Datastreams::CONTENT)
    end

    def has_extracted_text?
      has_datastream?(Ddr::Datastreams::EXTRACTED_TEXT)
    end

    def content_ds
      datastreams[Ddr::Datastreams::CONTENT]
    end

    def content_mime_type
      content_ds["dsMIME"] rescue nil
    end
    # For duck-typing with Ddr::Models::HasContent
    alias_method :content_type, :content_mime_type

    def content_checksum
      content_ds["dsChecksum"] rescue nil
    end

    def targets
      @targets ||= ActiveFedora::SolrService.query(targets_query)
    end

    def targets_count
      @targets_count ||= ActiveFedora::SolrService.count(targets_query)
    end

    def has_target?
      targets_count > 0
    end

    def association(name)
      get_pid(ActiveFedora::SolrService.solr_name(name, :symbol))
    end

    def controller_name
      active_fedora_model.tableize
    end

    def effective_license
      @effective_license ||= EffectiveLicense.call(self)
    end
    deprecation_deprecate :effective_license

    def rights_statement
      @rights_statement ||= RightsStatement.call(self) || EffectiveLicense.call(self)
    end

    def roles
      @roles ||= Ddr::Auth::Roles::DetachedRoleSet.from_json(access_role)
    end

    def structure
      JSON.parse(fetch(Ddr::Index::Fields::STRUCTURE))
    rescue
      nil
    end

    def effective_permissions(agents)
      Ddr::Auth::EffectivePermissions.call(self, agents)
    end

    def research_help
      research_help_contact = self[Ddr::Index::Fields::RESEARCH_HELP_CONTACT] || inherited_research_help_contact
      Ddr::Models::Contact.call(research_help_contact) if research_help_contact
    end

    def parent_uri
      is_part_of || is_member_of_collection
    end

    def has_parent?
      parent_uri.present?
    end

    def parent
      if has_parent?
        self.class.find(parent_uri)
      end
    end

    def multires_image_file_paths
      if structure
        structure_docs.map { |doc| doc.multires_image_file_path }.compact
      else
        []
      end
    end

    # DRY HasAdminMetadata
    def finding_aid
      if ead_id
        FindingAid.new(ead_id)
      end
    end

    def streamable?
      has_datastream?(Ddr::Datastreams::STREAMABLE_MEDIA)
    end

    def streamable_media_path
      if streamable?
        Ddr::Utils.path_from_uri(datastreams[Ddr::Datastreams::STREAMABLE_MEDIA]["dsLocation"])
      end
    end

    # FIXME - Probably need a more general solution mapping object reader methods to index field names.
    def rights
      self["rights_tesim"]
    end

    private

    def targets_query
      "#{Ddr::Index::Fields::IS_EXTERNAL_TARGET_FOR}:#{internal_uri_for_query}"
    end

    def internal_uri_for_query
      ActiveFedora::SolrService.escape_uri_for_query(internal_uri)
    end

    def get_date(field)
      parse_date(self[field])
    end

    def get_json(field)
      JSON.parse Array(self[field]).first
    end

    def parse_date(date)
      Time.parse(date).localtime if date
    end

    def get_pid(field)
      ActiveFedora::Base.pid_from_uri(self[field]) rescue nil
    end

    def inherited_research_help_contact
      if doc = admin_policy
        doc.research_help_contact
      end
    end

    def structure_docs
      structure_repo_ids.map { |repo_id| self.class.find(repo_id) }.compact
    end

    # For simplicity, initial implementation returns repo ID's only from top-level
    # (i.e., not nested) contents.  This is done since we have not clarified what
    # an _ordered_ list of repo ID's should look like if structure contains nested
    # contents.
    def structure_repo_ids
      default_struct_map['contents'].map { |content| content['contents'].map { |content| content['repo_id'] } }.flatten
    end

    def default_struct_map
      structure['default'] || structure.values.first
    end

  end
end
