require 'json'

module Ddr
  module Models
    module SolrDocument
      extend ActiveSupport::Concern

      included do
        alias_method :pid, :id
      end

      def to_partial_path
        'document'
      end

      def safe_id
        id.sub(/:/, "-")
      end

      def admin_set
        get(Ddr::IndexFields::ADMIN_SET)
      end

      def local_id
        get(Ddr::IndexFields::LOCAL_ID)
      end

      def active_fedora_model
        get(Ddr::IndexFields::ACTIVE_FEDORA_MODEL)
      end

      def internal_uri
        get(Ddr::IndexFields::INTERNAL_URI)
      end

      def object_profile
        @object_profile ||= get_json(Ddr::IndexFields::OBJECT_PROFILE)
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
        get_date(Ddr::IndexFields::LAST_FIXITY_CHECK_ON)
      end

      def last_fixity_check_outcome
        get(Ddr::IndexFields::LAST_FIXITY_CHECK_OUTCOME)
      end

      def last_virus_check_on
        get_date(Ddr::IndexFields::LAST_VIRUS_CHECK_ON)
      end

      def last_virus_check_outcome
        get(Ddr::IndexFields::LAST_VIRUS_CHECK_OUTCOME)
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
        get(Ddr::IndexFields::IS_GOVERNED_BY)
      end

      def admin_policy_pid
        uri = admin_policy_uri
        uri &&= ActiveFedora::Base.pid_from_uri(uri)
      end

      def admin_policy
        if admin_policy_pid
          query = ActiveFedora::SolrService.construct_query_for_pids([admin_policy_pid])
          self.class.new(ActiveFedora::SolrService.query(query).first)
        end
      end

      def has_children?
        ActiveFedora::SolrService.class_from_solr_document(self).reflect_on_association(:children).present?
      end

      def label
        object_profile["objLabel"]
      end

      def title
        get(Ddr::IndexFields::TITLE)
      end
      alias_method :title_display, :title # duck-type Ddr::Models::Base

      def principal_has_role?(principal, role)
        (Array(self["admin_metadata__#{role}_ssim"]) & Array(principal)).any?
      end

      def identifier
        # We want the multivalued version here
        get(ActiveFedora::SolrService.solr_name(:identifier, :stored_searchable, type: :text))
      end

      def source
        get(ActiveFedora::SolrService.solr_name(:source, :stored_searchable, type: :text))
      end

      def has_thumbnail?
        has_datastream?(Ddr::Datastreams::THUMBNAIL)
      end

      def has_content?
        has_datastream?(Ddr::Datastreams::CONTENT)
      end

      def content_ds
        datastreams[Ddr::Datastreams::CONTENT]
      end

      def content_mime_type
        content_ds["dsMIME"] rescue nil
      end
      # For duck-typing with Ddr::Models::HasContent
      alias_method :content_type, :content_mime_type

      def content_size
        get(Ddr::IndexFields::CONTENT_SIZE)
      end

      def content_size_human
        get(Ddr::IndexFields::CONTENT_SIZE_HUMAN)
      end

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

      def has_default_rights?
        has_datastream?(Ddr::Datastreams::DEFAULT_RIGHTS)
      end

      def association(name)
        get_pid(ActiveFedora::SolrService.solr_name(name, :symbol))
      end

      def controller_name
        active_fedora_model.tableize
      end

      def inherited_license
        if admin_policy_pid
          query = ActiveFedora::SolrService.construct_query_for_pids([admin_policy_pid])
          results = ActiveFedora::SolrService.query(query)
          doc = results.map { |result| ::SolrDocument.new(result) }.first
          { title: doc.get(Ddr::IndexFields::DEFAULT_LICENSE_TITLE),
            description: doc.get(Ddr::IndexFields::DEFAULT_LICENSE_DESCRIPTION),
            url: doc.get(Ddr::IndexFields::DEFAULT_LICENSE_URL) }
        end
      end

      def license
        if get(Ddr::IndexFields::LICENSE_TITLE) || get(Ddr::IndexFields::LICENSE_DESCRIPTION) || get(Ddr::IndexFields::LICENSE_URL)
          { title: get(Ddr::IndexFields::LICENSE_TITLE),
            description: get(Ddr::IndexFields::LICENSE_DESCRIPTION),
            url: get(Ddr::IndexFields::LICENSE_URL) }
        end
      end

      def effective_license
        @effective_license ||= license || inherited_license || {}
      end

      def permanent_id
        get(Ddr::IndexFields::PERMANENT_ID)
      end

      def multires_image_file_path
        get(Ddr::IndexFields::MULTIRES_IMAGE_FILE_PATH)
      end

      def roles
        @roles ||= Ddr::Auth::Roles::DetachedRoleSet.from_json(access_role)
      end

      def access_role
         get(Ddr::IndexFields::ACCESS_ROLE)
      end

      def display_format
        get(Ddr::IndexFields::DISPLAY_FORMAT)
      end

      def struct_maps
        JSON.parse(fetch(Ddr::IndexFields::STRUCT_MAPS))
      rescue
        {}
      end

      def struct_map(type='default')
        struct_maps.present? ? struct_maps.fetch(type) : nil
      end

      private

      def targets_query
        "#{Ddr::IndexFields::IS_EXTERNAL_TARGET_FOR}:#{internal_uri_for_query}"
      end

      def internal_uri_for_query
        ActiveFedora::SolrService.escape_uri_for_query(internal_uri)
      end

      def get_date(field)
        parse_date(get(field))
      end

      def get_json(field)
        JSON.parse Array(self[field]).first
      end

      def parse_date(date)
        Time.parse(date).localtime if date
      end

      def get_pid(field)
        ActiveFedora::Base.pid_from_uri(get(field)) rescue nil
      end

    end
  end
end
