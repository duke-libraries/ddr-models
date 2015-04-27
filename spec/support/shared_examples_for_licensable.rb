RSpec.shared_examples "a licensable object" do
  let(:object) { described_class.new }
  before do
    object.license_title = "License Title"
    object.license_description = "License Description"
    object.license_url = "http://library.duke.edu"
  end
  describe "indexing" do
    it "should index the license terms" do
      expect(object.to_solr[Ddr::IndexFields::LICENSE_TITLE]).to eq("License Title")
      expect(object.to_solr[Ddr::IndexFields::LICENSE_DESCRIPTION]).to eq("License Description")
      expect(object.to_solr[Ddr::IndexFields::LICENSE_URL]).to eq("http://library.duke.edu")
    end
  end
end
