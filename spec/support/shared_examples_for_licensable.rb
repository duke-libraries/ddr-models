RSpec.shared_examples "a licensable object" do
  let(:object) { described_class.new }
  before do
    object.license_title = "License Title"
    object.license_description = "License Description"
    object.license_url = "http://library.duke.edu"
  end
  describe "indexing" do
    it "should index the license terms" do
      expect(object.to_solr.keys).to include(Ddr::IndexFields::LICENSE_TITLE,
                                             Ddr::IndexFields::LICENSE_DESCRIPTION,
                                             Ddr::IndexFields::LICENSE_URL)
    end
  end
end