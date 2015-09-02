require 'spec_helper'

RSpec.describe Component, type: :model, components: true do

  it_behaves_like "a DDR model"
  it_behaves_like "an object that can have content"
  it_behaves_like "it has an association", :belongs_to, :parent, :is_part_of, "Item"
  it_behaves_like "it has an association", :belongs_to, :target, :has_external_target, "Target"
  it_behaves_like "a non-collection model"

  describe "indexing" do
    subject { FactoryGirl.build(:component) }
    before do
      allow(subject).to receive(:collection) { Collection.new(pid: "test:1") }
    end
    its(:index_fields) { is_expected.to include(Ddr::IndexFields::COLLECTION_URI => "info:fedora/test:1") }
  end

end
