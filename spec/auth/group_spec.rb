module Ddr::Auth
  RSpec.describe Group do

    it { is_expected.to be_a(Agent) }
    
    describe "RDF type" do
      it "should be foaf:Group" do
        expect(subject.type.first).to eq(RDF::FOAF.Group)
      end
    end

  end
end
