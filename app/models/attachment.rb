#
# An Attachment is a miscellaneous content-bearing resource associated with a Collection.
#
# Example: A collection digitization QC information spreadsheet.
#
class Attachment < Ddr::Models::Base

  include Ddr::Models::HasContent

  belongs_to :attached_to,
             predicate: ::RDF::URI("http://projecthydra.org/ns/relations#isAttachedTo"),
             class_name: "ActiveFedora::Base"

end
