require 'spec_helper'

RSpec.describe Collection, :type => :model do

  it_behaves_like "a DDR model"
  
  it_behaves_like "it has an association", :has_many, :children, :is_member_of_collection, "Item"

  it_behaves_like "it has an association", :has_many, :targets, :is_external_target_for, "Target"

  describe "terms delegated to defaultRights" do
    let(:collection) { Collection.new }
    before do
      collection.default_license_title = "License Title"
      collection.default_license_description = "License Description"
      collection.default_license_url = "http://library.duke.edu"
    end
    it "should set the terms correctly" do
      expect(collection.defaultRights.license.title.first).to eq("License Title")
      expect(collection.defaultRights.license.description.first).to eq("License Description")
      expect(collection.defaultRights.license.url.first).to eq("http://library.duke.edu")
    end
  end

  context "validation" do
    let(:collection) { Collection.new }
    it "should require a title" do
      expect(collection).to_not be_valid
      expect(collection.errors.messages).to have_key(:title)
    end
  end

end
