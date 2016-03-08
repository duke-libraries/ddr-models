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

  def children_having_extracted_text
    item = self
    Ddr::Index::Query.new do
      is_part_of item
      where attached_files_having_content: "extractedText"
      fields :id, :extracted_text
    end
  end

  def all_text
    children_having_extracted_text.docs.map(&:extracted_text).flatten
  end

end
