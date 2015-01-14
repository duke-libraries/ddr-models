require 'spec_helper'

RSpec.describe Component, type: :model, components: true do
  it_behaves_like "a DDR model"
  it_behaves_like "an object that can have content"
  it_behaves_like "it has an association", :belongs_to, :parent, :is_part_of, "Item"
  it_behaves_like "it has an association", :belongs_to, :target, :has_external_target, "Target"

  describe "indexing" do
    let(:component) { FactoryGirl.build(:component) }
    before do
      allow_any_instance_of(Component).to receive(:collection) { Collection.new(pid: 'test:1') }
    end
    it "should include the COLLECTION_URI field in its indexing" do
      expect(component.indexes).to have_key(:collection_uri)
    end
  end
end
