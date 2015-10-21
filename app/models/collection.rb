#
# A Collection is a conceptual and administrative entity containing a set of items.
#
class Collection < Ddr::Models::Base

  include Ddr::Models::HasChildren
  include Ddr::Models::HasAttachments

  has_many :children, property: :is_member_of_collection, class_name: 'Item', as: :parent
  has_many :targets, property: :is_external_target_for, class_name: 'Target'

  after_create :set_admin_policy

  validates_presence_of :dc_title

  # Returns the SolrDocuments for Components associated with the Collection.
  #
  # @return A lazy enumerator of SolrDocuments.
  def components_from_solr
    query = "#{Ddr::Index::Fields::COLLECTION_URI}:#{RSolr.solr_escape(id)}"
    filter = ActiveFedora::SolrService.construct_query_for_rel(:has_model => Component.to_class_uri)
    results = ActiveFedora::SolrService.query(query, fq: filter, rows: 100000)
    results.lazy.map {|doc| SolrDocument.new(doc)}
  end

  # Returns a list of entities (either users or groups) having a default access
  # level on objects governed by the Collection.
  #
  # @param type [String] the type of entity, "user" or "group".
  # @param access [String] the default access level, "discover", "read", or "edit".
  # @return [Array<String>] the entities (users or groups)
  def default_entities_for_permission(type, access)
    default_permissions.collect { |p| p[:name] if p[:type] == type and p[:access] == access }.compact
  end

  ["discover", "read", "edit"].each do |access|
    ["user", "group"].each do |type|
      define_method("default_#{access}_#{type}s") { default_entities_for_permission(type, access) }
    end
  end

  def grant_roles_to_creator(creator)
    roles.grant type: Ddr::Auth::Roles::CURATOR, agent: creator.agent, scope: Ddr::Auth::Roles::RESOURCE_SCOPE
    roles.grant type: Ddr::Auth::Roles::CURATOR, agent: creator.agent, scope: Ddr::Auth::Roles::POLICY_SCOPE
  end

  private

  def set_admin_policy
    self.admin_policy = self
    self.save
  end

end
