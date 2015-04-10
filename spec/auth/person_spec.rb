module Ddr::Auth
  RSpec.describe Person, agents: true do

    subject { FactoryGirl.build(:person) }

    it_behaves_like "an agent" do
      let(:type) { RDF::FOAF.Person }
      let(:agent_type) { :person }
    end

    describe "validation" do
      describe "when built with a name is not in the format of an email address" do
        it "should raise an exception" do
          expect { described_class.build("bob") }.to raise_error
        end
      end
    end

  end
end
