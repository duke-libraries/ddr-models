module Ddr::Auth
  RSpec.describe LegacyPermissions do

    subject { described_class.new(obj) }

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

    it "should convert the permissions to resource roles" do
      expect(subject.to_roles)
        .to eq(Roles::DetachedRoleSet.new(
                [ Roles::Role.build(type: "Editor", agent: "Editors", scope: "resource"),
                  Roles::Role.build(type: "Viewer", agent: "public", scope: "resource"),
                  Roles::Role.build(type: "Viewer", agent: "bob@example.com", scope: "resource")
                ]
              ))
    end

    it "should clear the legacy permissions" do
      expect(obj.permissions).not_to be_empty
      subject.clear
      expect(obj.permissions).to be_empty
    end

  end
end
