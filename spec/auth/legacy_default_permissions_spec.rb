module Ddr::Auth
  RSpec.describe LegacyDefaultPermissions do

    subject { described_class.new(obj) }

    let(:obj) { FactoryGirl.build(:collection) }

    before do
      @deprecation_behavior = Deprecation.default_deprecation_behavior
      Deprecation.default_deprecation_behavior = :silence
      obj.default_permissions = [{access: "edit", type: "group", name: "Editors"},
                                 {access: "discover", type: "group", name: "public"},
                                 {access: "read", type: "person", name: "bob@example.com"}]
    end
    
    after do
      Deprecation.default_deprecation_behavior = @deprecation_behavior
    end

    it "should convert the default permissions to policy roles" do
      expect(subject.to_roles)
        .to eq(Roles::DetachedRoleSet.new(
                [ Roles::Role.build(type: "Curator", agent: "Editors", scope: "policy"),
                  Roles::Role.build(type: "Viewer", agent: "public", scope: "policy"),
                  Roles::Role.build(type: "Viewer", agent: "bob@example.com", scope: "policy")
                ]
              ))
    end

  end
end
