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
      expect(component.index_fields).to have_key(Ddr::IndexFields::COLLECTION_URI)
      expect(component.index_fields[Ddr::IndexFields::COLLECTION_URI]).to eq('info:fedora/test:1')
    end
  end
end
