#
# A Target is digital scanner calibration artifact.
#
# A Target has a content file and is associated with a Collection OR one or more Components.
#
# See http://www.loc.gov/standards/mix/ and NISO Z39.87.
#
class Target < Ddr::Models::Base

  include Ddr::Models::HasContent

  has_many :components,
           predicate: ::RDF::URI("http://www.loc.gov/mix/v20/externalTarget#hasExternalTarget"),
           class_name: "Component"

  belongs_to :collection,
             predicate: ::RDF::URI("http://www.loc.gov/mix/v20/externalTarget#isExternalTargetFor"),
             class_name: "Collection"

end
