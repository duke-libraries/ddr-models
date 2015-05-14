module Ddr::Auth
  RSpec.describe LegacyPermissions do

    subject { described_class.new(obj.permissions) }

    let(:obj) { FactoryGirl.build(:item) }

    before do
      @deprecation_behavior = Deprecation.default_deprecation_behavior
      Deprecation.default_deprecation_behavior = :silence
      obj.permissions_attributes = [{access: "edit", type: "group", name: "Editors"},
                                    {access: "discover", type: "group", name: "public"},
                                    {access: "read", type: "person", name: "bob@example.com"}]
    end
    
    after do
      Deprecation.default_deprecation_behavior = @deprecation_behavior
    end

    it "should be able to convert the permissions to policy roles" do
      expect(subject.to_policy_roles)
        .to eq(Roles::DetachedRoleSet.new([Roles::Role.build(type: "Editor", agent: "Editors", scope: "policy"),
                                           Roles::Role.build(type: "Viewer", agent: "public", scope: "policy"),
                                           Roles::Role.build(type: "Viewer", agent: "bob@example.com", scope: "policy")]))
    end

    it "should be able to convert the permissions to resource roles" do
      expect(subject.to_resource_roles)
        .to eq(Roles::DetachedRoleSet.new([Roles::Role.build(type: "Editor", agent: "Editors", scope: "resource"),
                                           Roles::Role.build(type: "Viewer", agent: "public", scope: "resource"),
                                           Roles::Role.build(type: "Viewer", agent: "bob@example.com", scope: "resource")]))
    end
    
  end
end
