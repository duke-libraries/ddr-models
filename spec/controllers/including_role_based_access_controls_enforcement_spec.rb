RSpec.describe ApplicationController, type: :controller do

  controller do
    include Hydra::AccessControlsEnforcement
    include Ddr::Auth::RoleBasedAccessControlsEnforcement
  end

  let(:user) { FactoryGirl.create(:user) }

  before do
    allow(controller.current_ability).to receive(:agents) { [ user.agent, "foo", "bar" ] }
  end

  describe "#resource_role_filters" do
    it "should include clauses for each agent for the current ability" do
      expect(subject.resource_role_filters.split(" OR "))
        .to contain_exactly("_query_:\"{!raw f=resource_role_sim}foo\"",
                            "_query_:\"{!raw f=resource_role_sim}bar\"",
                            "_query_:\"{!raw f=resource_role_sim}#{user.agent}\"")
    end
  end

  describe "#policy_role_policies" do
    let(:collections) { FactoryGirl.build_list(:collection, 3) }
    before do
      collections[0].roles.grant type: "Curator", agent: user, scope: "policy"
      collections[0].save
      collections[1].roles.grant type: "Editor", agent: "foo", scope: "policy"
      collections[1].roles.grant type: "Contributor", agent: "bar", scope: "policy"
      collections[1].save
      collections[2].roles.grant type: "Viewer", agent: "foo:bar", scope: "policy"
      collections[2].save
    end
    it "should return a list of PIDs for collections on which the current ability has a role" do
      expect(subject.policy_role_policies).to match_array([collections[0].pid, collections[1].pid])
    end
  end

  describe "#policy_role_filters" do
    before do
      allow(subject).to receive(:policy_role_policies) { ["test:13", "test:45"] }
    end
    it "should include clauses for is_governed_by relationships to the #policy_role_policies PIDs" do
      expect(subject.policy_role_filters).to eq("_query_:\"{!raw f=#{Ddr::IndexFields::IS_GOVERNED_BY}}test:13\" OR _query_:\"{!raw f=#{Ddr::IndexFields::IS_GOVERNED_BY}}test:45\"")
    end
  end

end
