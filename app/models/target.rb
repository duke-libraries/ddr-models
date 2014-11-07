#
# A Target is digital scanner calibration artifact.
#
# A Target has a content file and is associated with a Collection OR one or more Components.
#
# See http://www.loc.gov/standards/mix/ and NISO Z39.87.
#
class Target < Ddr::Models::Base

  include Ddr::Models::HasContent

  has_many :components, property: :has_external_target, class_name: 'Component'
  belongs_to :collection, property: :is_external_target_for, class_name: 'Collection'

end
