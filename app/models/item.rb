#
# An Item is a  member of a Collection -- i.e., a "work" -- the principal describable resource.
#
# Examples: photograph, book, article, sound recording, video, etc.
#
class Item < Ddr::Models::Base

  include Ddr::Models::HasChildren
  include Ddr::Models::HasStructMetadata

  has_many :children,
           predicate: ActiveFedora::RDF::Fcrepo::RelsExt.isPartOf,
           class_name: "Component",
           as: :parent

  belongs_to :parent,
             predicate: ActiveFedora::RDF::Fcrepo::RelsExt.isMemberOfCollection,
             class_name: "Collection"

  def publishable?
    parent.present? && parent.published?
  end

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
