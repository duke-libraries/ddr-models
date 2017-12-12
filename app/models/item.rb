#
# An Item is a  member of a Collection -- i.e., a "work" -- the principal describable resource.
#
# Examples: photograph, book, article, sound recording, video, etc.
#
class Item < Ddr::Models::Base

  include Ddr::Models::HasChildren
  include Ddr::Models::HasStructMetadata

  has_many :children, property: :is_part_of, class_name: 'Component'
  belongs_to :parent, property: :is_member_of_collection, class_name: 'Collection'

  alias_method :components, :children
  alias_method :component_ids, :child_ids

  alias_method :parts, :children
  alias_method :part_ids, :child_ids

  alias_method :collection, :parent
  alias_method :collection_id, :parent_id
  alias_method :collection=, :parent=

  def publishable?
    parent.present? && parent.published?
  end

  def children_having_extracted_text
    Ddr::Index::Query.build(self) do |item|
      is_part_of item
      where attached_files_having_content: "extractedText"
      fields :id, :extracted_text
    end
  end

  def all_text
    children_having_extracted_text.docs.map(&:extracted_text).flatten
  end

  def default_structure
    build_default_structure
  end

  private

  def build_default_structure
    document = Ddr::Models::Structure.xml_template
    structure = Ddr::Models::Structure.new(document)
    metshdr = structure.add_metshdr
    structure.add_agent(parent: metshdr, role: Ddr::Models::Structures::Agent::ROLE_CREATOR,
                        name: Ddr::Models::Structures::Agent::NAME_REPOSITORY_DEFAULT)
    structmap = structure.add_structmap(type: Ddr::Models::Structure::TYPE_DEFAULT)
    add_components_to_structure(structure, structmap)
    structure
  end

  def add_components_to_structure(structure, structmap)
    component_structure_types(sorted_children).each do |type_term, children|
      div = structure.add_div(parent: structmap, type: type_term)
      children.each_with_index do |child, index|
        sub_div = structure.add_div(parent: div, order: index + 1)
        structure.add_mptr(parent: sub_div, href: child[Ddr::Index::Fields::PERMANENT_ID])
      end
    end
  end

  def component_structure_types(sorted_children)
    type_divs = {}
    sorted_children.each do |child|
      term = type_term(child) || "Other"
      if type_divs.has_key?(term)
        type_divs[term] << child
      else
        type_divs[term] = [ child ]
      end
    end
    type_divs
  end

  def type_term(component_doc)
    media_type = component_doc[Ddr::Index::Fields::MEDIA_TYPE].first
    Ddr::Models::Structures::ComponentTypeTerm.term(media_type)
  end

end
