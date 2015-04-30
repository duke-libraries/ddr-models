require 'spec_helper'

RSpec.describe Item, :type => :model do
  it_behaves_like "a DDR model"
  it_behaves_like "it has an association", :belongs_to, :parent, :is_member_of_collection, "Collection"
  it_behaves_like "it has an association", :has_many, :children, :is_part_of, "Component"

  context "has structured children" do
    let!(:item) { Item.create }
    let!(:comp1) { Component.create(parent: item, file_use: 'master', order: 2) }
    let!(:comp2) { Component.create(parent: item, file_use: 'reference', order: 1) }
    let!(:comp3) { Component.create(parent: item, file_use: 'master', order: 1) }
    it "should group and order the children" do
      results = item.children_by_file_use
      expect(results['master']).to eq([ comp3, comp1 ])
      expect(results['reference']).to eq([ comp2 ])
    end
  end

end
