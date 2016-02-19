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

end
