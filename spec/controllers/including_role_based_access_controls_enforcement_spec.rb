RSpec.describe ApplicationController, type: :controller do

  controller do
    include Hydra::AccessControlsEnforcement
    include Ddr::Auth::RoleBasedAccessControlsEnforcement    
  end

  let(:user) { FactoryGirl.create(:user) }

  before do
    sign_in user
    allow(controller.current_user).to receive(:agents) { [Ddr::Auth::Group.build("foo"), Ddr::Auth::Group.build("bar"), Ddr::Auth::Person.build(user)] }
  end

  describe "#resource_role_filters" do
    it "should include clauses for each agent for the current user" do
      expect(subject.resource_role_filters).to eq("resource_role_sim:\"foo\" OR resource_role_sim:\"bar\" OR resource_role_sim:\"#{user.name}\"")
    end
  end

  describe "#role_policies" do
    let(:collections) { FactoryGirl.build_list(:collection, 3) }
    before do
      collections[0].roles.grant type: :curator, person: user, scope: :policy
      collections[0].save
      collections[1].roles.grant type: :editor, group: "foo", scope: :policy
      collections[1].roles.grant type: :contributor, group: "bar", scope: :policy
      collections[1].save
      collections[2].roles.grant type: :viewer, group: "foo:bar", scope: :policy
      collections[2].save
    end
    it "should return a list of PIDs for collections on which the current user has a role" do
      expect(subject.role_policies).to match_array([collections[0].pid, collections[1].pid])
    end
  end

  describe "#policy_role_filters" do
    before do
      allow(subject).to receive(:role_policies) { ["test:13", "test:45"] }
    end
    it "should include clauses for is_governed_by relationships to the #role_policies PIDs" do
      expect(subject.policy_role_filters).to eq("_query_:\"{!raw f=is_governed_by_ssim}test:13\" OR _query_:\"{!raw f=is_governed_by_ssim}test:45\"")
    end
  end

end