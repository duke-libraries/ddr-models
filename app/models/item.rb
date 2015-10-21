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

end
