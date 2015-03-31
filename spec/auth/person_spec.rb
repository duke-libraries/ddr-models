module Ddr::Auth
  RSpec.describe Person do

    it { is_expected.to be_a(Agent) }
    
    describe "RDF type" do
      it "should be foaf:Person" do
        expect(subject.type.first).to eq(RDF::FOAF.Person)
      end
    end

  end
end
