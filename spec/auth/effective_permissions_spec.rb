module Ddr::Auth
  RSpec.describe EffectivePermissions do

    let(:resource) { FactoryGirl.build(:item) }
    let(:policy) { Collection.new(pid: "coll-1") }
    let(:agents) { [ "Editors", "bob@example.com" ] }
    
    before do
      resource.admin_policy = policy
      resource.roles.grant FactoryGirl.build(:role, :downloader, :public)
      policy.roles.grant type: "Editor", agent: "Editors", scope: "policy"
    end

    it "should return the list of permissions granted to the agents on the resource in resource scope, plus the permissions granted to the agents on the resource's policy in policy scope" do
      expect(described_class.call(resource, agents))
        .to contain_exactly(:read, :download, :add_children, :update, :replace, :arrange)
    end
    
  end
end
