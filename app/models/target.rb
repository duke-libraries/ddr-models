class Target < Ddr::Models::Base

  include Ddr::Models::HasContent

  has_many :components, property: :has_external_target, class_name: 'Component'
  belongs_to :collection, property: :is_external_target_for, class_name: 'Collection'

end