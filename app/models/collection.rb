#
# A Collection is a conceptual and administrative entity containing a set of items. 
#
# Provides default permissions (Hydra admin policy) for objects associated with the collection 
# via an isGovernedBy relation.
#
class Collection < Ddr::Models::Base

  include Hydra::AdminPolicyBehavior

  include Ddr::Models::HasChildren
  include Ddr::Models::HasAttachments

  has_attributes :default_license_title, datastream: Ddr::Datastreams::DEFAULT_RIGHTS, at: [:license, :title], multiple: false
  has_attributes :default_license_description, datastream: Ddr::Datastreams::DEFAULT_RIGHTS, at: [:license, :description], multiple: false
  has_attributes :default_license_url, datastream: Ddr::Datastreams::DEFAULT_RIGHTS, at: [:license, :url], multiple: false

  has_many :children, property: :is_member_of_collection, class_name: 'Item'
  has_many :targets, property: :is_external_target_for, class_name: 'Target'

  alias_method :items, :children
  alias_method :item_ids, :child_ids

  after_create :set_admin_policy

  validates_presence_of :title

  # Returns the SolrDocuments for Components associated with the Collection through its member Items.
  #
  # @return A lazy enumerator of SolrDocuments.
  def components_from_solr
    outer = Ddr::IndexFields::IS_PART_OF
    inner = Ddr::IndexFields::INTERNAL_URI
    where = ActiveFedora::SolrService.construct_query_for_rel(:is_member_of_collection => internal_uri)
    query = "{!join to=#{outer} from=#{inner}}#{where}"
    filter = ActiveFedora::SolrService.construct_query_for_rel(:has_model => Component.to_class_uri)
    results = ActiveFedora::SolrService.query(query, fq: filter, rows: 100000)
    results.lazy.map {|doc| SolrDocument.new(doc)}
  end

  # Returns the license attributes provided as default values for objects governed by the Collection.
  #
  # @return [Hash] the attributes, `:title`, `:description`, and `:url`.
  def default_license
    if default_license_title.present? or default_license_description.present? or default_license_url.present?
      {title: default_license_title, description: default_license_description, url: default_license_url}
    end
  end

  # Sets the default license attributes for objects governed by the Collection.
  def default_license=(new_license)
    raise ArgumentError unless new_license.is_a?(Hash) # XXX don't do this - not duck-typeable
    l = new_license.with_indifferent_access
    self.default_license_title = l[:title]
    self.default_license_description = l[:description]
    self.default_license_url = l[:url]
  end

  # Returns a list of entities (either users or groups) having a default access level on objects governed by the Collection.
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

  private

  def set_admin_policy
    self.admin_policy = self
    self.save
  end

end
