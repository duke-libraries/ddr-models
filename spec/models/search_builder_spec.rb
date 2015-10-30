require 'blacklight'

module Ddr::Models
  RSpec.describe SearchBuilder do

    subject { search_builder_class.new(processor_chain, scope) }

    let(:search_builder_class) do
      Class.new(Blacklight::Solr::SearchBuilder) do
        include Ddr::Models::SearchBuilder
      end
    end

    let(:processor_chain) { [] }
    let(:ability) { double(agents: ["foo", "bar"]) }
    let(:scope) { double(current_ability: ability) }

    describe "#resource_role_filters" do
      it "returns a list of clauses for each agent for the current ability" do
        expect(subject.resource_role_filters.split(" OR "))
          .to contain_exactly("_query_:\"{!raw f=#{Ddr::Index::Fields::RESOURCE_ROLE}}foo\"",
                              "_query_:\"{!raw f=#{Ddr::Index::Fields::RESOURCE_ROLE}}bar\"")
      end
    end

    describe "#policy_role_policies" do
      let(:collections) { FactoryGirl.build_list(:collection, 3) }
      before do
        collections[0].roles.grant type: "Editor", agent: "foo", scope: "policy"
        collections[0].save
        collections[1].roles.grant type: "Contributor", agent: "bar", scope: "policy"
        collections[1].save
        collections[2].roles.grant type: "Viewer", agent: "foo:bar", scope: "policy"
        collections[2].save
      end
      it "returns a list of IDs for collections on which the current ability has a role" do
        expect(subject.policy_role_policies).to match_array([collections[0].id, collections[1].id])
      end
    end

    describe "#policy_role_filters" do
      before do
        allow(subject).to receive(:policy_role_policies) { ["test-13", "test-45"] }
      end
      it "should include clauses for isGovernedBy relationships to the #policy_role_policies" do
        expect(subject.policy_role_filters).to eq("_query_:\"{!raw f=#{Ddr::Index::Fields::IS_GOVERNED_BY}}test-13\" OR _query_:\"{!raw f=#{Ddr::Index::Fields::IS_GOVERNED_BY}}test-45\"")
      end
    end

  end
end
