module Ddr::Auth
  RSpec.describe Group, agents: true do

    subject { FactoryGirl.build(:group) }

    it_behaves_like "an agent" do
      let(:type) { RDF::FOAF.Group }
      let(:agent_type) { :group }
    end

    describe "validation" do
      describe "when built with a name is in the format of an email address" do
        it "should raise an exception" do
          expect { described_class.build("bob@example.com") }.to raise_error
        end
      end
    end

    describe "backward-compatible behavior" do
      it "should delegate missing methods to the group name string" do
        name = subject.to_s
        expect(subject.sub("Group", "Apple")).to eq(name.sub("Group", "Apple"))
      end
    end

  end
end
