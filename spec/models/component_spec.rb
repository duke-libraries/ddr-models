require 'spec_helper'

RSpec.describe Component, type: :model, components: true do
  it_behaves_like "a DDR model"
  it_behaves_like "an object that can have content"
  it_behaves_like "it has an association", :belongs_to, :parent, :is_part_of, "Item"
  it_behaves_like "it has an association", :belongs_to, :target, :has_external_target, "Target"
end
