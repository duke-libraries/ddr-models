module Ddr::Auth
  RSpec.describe EffectiveRoles do
    
    let(:resource) { FactoryGirl.build(:item) }
    let(:policy) { Collection.new(pid: "coll-1") }
    let(:agents) { [ "Editors", "bob@example.com", "public" ] }
    let(:editor) { Roles::Role.build type: "Editor", agent: "Editors", scope: "policy" }
    let(:downloader) { FactoryGirl.build(:role, :downloader, :public) }
    
    before do
      resource.admin_policy = policy
      resource.roles.grant downloader
      policy.roles.grant editor
    end

    it "should return the list of roles granted to the agents on the resource in resource scope, plus the roles granted to the agents on the resource's policy in policy scope" do
      expect(described_class.call(resource, agents).detach)
        .to eq(Roles::DetachedRoleSet.new([downloader, editor]))
    end

  end
end
