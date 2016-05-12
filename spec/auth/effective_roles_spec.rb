module Ddr::Auth
  RSpec.describe EffectiveRoles do
    
    let(:resource) { FactoryGirl.build(:item) }
    let(:policy) { Collection.new(id: "coll-1") }
    let(:agents) { [ "Editors", "bob@example.com", "public" ] }
    let(:editor) { Roles::Role.new role_type: "Editor", agent: "Editors", scope: "policy" }
    let(:downloader) { FactoryGirl.build(:role, :downloader, :public) }
    
    before do
      resource.admin_policy = policy
      resource.roles.grant downloader
      policy.roles.grant editor
    end

    it "returns the list of roles granted to the agents on the resource in resource scope, plus the roles granted to the agents on the resource's policy in policy scope" do
      expect(described_class.call(resource, agents))
        .to eq(Roles::RoleSet.new(roles: [downloader, editor]))
    end

  end
end
