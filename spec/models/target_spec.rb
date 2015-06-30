require 'spec_helper'

RSpec.describe Target, type: :model, targets: true do

  it_behaves_like "a DDR model"
  it_behaves_like "an object that can have content"
  it_behaves_like "it has an association", :has_many, :components, :has_external_target, "Component"
  it_behaves_like "it has an association", :belongs_to, :collection, :is_external_target_for, "Collection"
  it_behaves_like "a non-collection model"

end
