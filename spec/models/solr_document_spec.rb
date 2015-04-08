RSpec.describe SolrDocument do

  describe "#permanent_id" do
    before { subject[Ddr::IndexFields::PERMANENT_ID] = "foo" }
    its(:permanent_id) { is_expected.to eq("foo") }
  end


end
