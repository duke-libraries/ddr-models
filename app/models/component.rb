#
# A Component is a part of an Item; the principal content-bearing repository resource.
#
# Examples: Page of a book, track of a recording, etc.
#
class Component < Ddr::Models::Base

  include Ddr::Models::HasContent
  include Ddr::Models::HasMultiresImage
  include Ddr::Models::HasStructMetadata

  belongs_to :parent, :property => :is_part_of, :class_name => 'Item'
  belongs_to :target, :property => :has_external_target, :class_name => 'Target'

  def collection
    self.parent.parent rescue nil
  end

  def collection_id
    collection.id rescue nil
  end

end
