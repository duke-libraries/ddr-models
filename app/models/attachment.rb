#
# An Attachment is a miscellaneous content-bearing resource associated with a Collection.
#
# Example: A collection digitization QC information spreadsheet.
#
class Attachment < Ddr::Models::Base

  include Ddr::Models::HasContent

  # belongs_to :attached_to, property: :is_attached_to, class_name: 'ActiveFedora::Base'

  def publishable?
    false
  end

end
