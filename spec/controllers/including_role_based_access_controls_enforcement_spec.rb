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
        .to contain_exactly("_query_:\"{!raw f=#{Ddr::IndexFields::RESOURCE_ROLE}}foo\"",
                            "_query_:\"{!raw f=#{Ddr::IndexFields::RESOURCE_ROLE}}bar\"",
                            "_query_:\"{!raw f=#{Ddr::IndexFields::RESOURCE_ROLE}}#{user.agent}\"")
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
    it "should return a list of internal URIs for collections on which the current ability has a role" do
      expect(subject.policy_role_policies).to match_array([collections[0].internal_uri, collections[1].internal_uri])
    end
  end

  describe "#policy_role_filters" do
    before do
      allow(subject).to receive(:policy_role_policies) { ["info:fedora/test:13", "info:fedora/test:45"] }
    end
    it "should include clauses for is_governed_by relationships to the #policy_role_policies" do
      expect(subject.policy_role_filters).to eq("_query_:\"{!raw f=#{Ddr::IndexFields::IS_GOVERNED_BY}}info:fedora/test:13\" OR _query_:\"{!raw f=#{Ddr::IndexFields::IS_GOVERNED_BY}}info:fedora/test:45\"")
    end
  end

end
