require 'htmlentities'
#
# A Collection is a conceptual and administrative entity containing a set of items.
#
class Collection < Ddr::Models::Base

  include Ddr::Models::HasChildren
  include Ddr::Models::HasAttachments
  include Ddr::Models::HasStructMetadata

  has_many :children, property: :is_member_of_collection, class_name: 'Item'
  has_many :targets, property: :is_external_target_for, class_name: 'Target'

  alias_method :items, :children
  alias_method :item_ids, :child_ids

  after_create :set_admin_policy, unless: :admin_policy

  validates_presence_of :admin_set, :title

  # Returns the SolrDocuments for Components associated with the Collection.
  #
  # @return A lazy enumerator of SolrDocuments.
  def components_from_solr
    query = "#{Ddr::Index::Fields::COLLECTION_URI}:#{RSolr.solr_escape(internal_uri)}"
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
    roles.grant type: Ddr::Auth::Roles::CURATOR, agent: creator.agent, scope: Ddr::Auth::Roles::POLICY_SCOPE
  end

  def publishable?
    true
  end

  def default_structure
    if items.present?
      build_default_structure
    end
  end

  private

  def default_roles
    super.tap do |roles|
      if Ddr::Auth.metadata_managers_group
        roles << { type: Ddr::Auth::Roles::METADATA_EDITOR,
                   agent: Ddr::Auth.metadata_managers_group,
                   scope: Ddr::Auth::Roles::POLICY_SCOPE }
      end
    end
  end

  def set_admin_policy
    reload
    self.admin_policy = self
    save!
  end

  def build_default_structure
    document = Ddr::Models::Structure.xml_template
    structure = Ddr::Models::Structure.new(document)
    metshdr = structure.add_metshdr
    structure.add_agent(parent: metshdr, role: Ddr::Models::Structures::Agent::ROLE_CREATOR,
                        name: Ddr::Models::Structures::Agent::NAME_REPOSITORY_DEFAULT)
    structmap = structure.add_structmap(type: Ddr::Models::Structure::TYPE_DEFAULT)
    add_items_to_structure(structure, structmap)
    structure
  end

  def add_items_to_structure(structure, structmap)
    sorted_items_for_structure.each do |item|
      if path = item[Ddr::Index::Fields::NESTED_PATH]
        nest = path.split(File::SEPARATOR)
      else
        nest = []
      end
      find_or_create_div(structure, structmap, nest, item[Ddr::Index::Fields::PERMANENT_ID])
    end
  end

  def find_or_create_div(structure, parent, nest, permanent_id)
    label = nest.shift
    order = parent.elements.count + 1
    if nest.empty?
      div = structure.add_div(parent: parent, order: order)
      add_mptr(structure, div, permanent_id)
    else
      label = HTMLEntities.new.encode(label)
      div = parent.xpath(%Q[xmlns:div[@LABEL="#{label}"]]).first ||
            structure.add_div(parent: parent, type: 'Directory', label: label, order: order)
      find_or_create_div(structure, div, nest, permanent_id)
    end
  end

  def add_mptr(structure, div, permanent_id)
    structure.add_mptr(parent: div, href: permanent_id)
  end

  def sorted_items_for_structure
    ActiveFedora::SolrService.query(association_query(:children), sort: item_sort_for_structure, rows: 999999)
  end

  def item_sort_for_structure
    "#{Ddr::Index::Fields::NESTED_PATH} ASC,
     #{Ddr::Index::Fields::LOCAL_ID} ASC,
     #{Ddr::Index::Fields::OBJECT_CREATE_DATE} ASC"
  end

end
