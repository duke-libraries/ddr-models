module Ddr::Auth
  RSpec.describe LegacyAuthorization do

    subject { described_class.new(obj) }

    before do
      @deprecation_behavior = Deprecation.default_deprecation_behavior
      Deprecation.default_deprecation_behavior = :silence
    end

    after do
      Deprecation.default_deprecation_behavior = @deprecation_behavior
    end


    describe "with a Collection" do
      let(:obj) { FactoryGirl.build(:collection) }

      before do
        obj.permissions_attributes = [{access: "edit", type: "person", name: "bob@example.com"}]
        obj.default_permissions = [{access: "edit", type: "group", name: "Editors"},
                                   {access: "discover", type: "group", name: "public"},
                                   {access: "read", type: "group", name: "registered"}]
      end

      it "should convert the legacy authorization to roles" do
        expect(subject.to_roles)
          .to eq(Roles::DetachedRoleSet.new(
                  [ Roles::Role.build(type: "Curator", agent: "Editors", scope: "policy"),
                    Roles::Role.build(type: "Viewer", agent: "public", scope: "policy"),
                    Roles::Role.build(type: "Viewer", agent: "registered", scope: "policy"),
                    Roles::Role.build(type: "Editor", agent: "bob@example.com", scope: "resource") ]
                ))
      end
    end

    describe "with a Component" do
      let(:obj) { FactoryGirl.build(:component) }

      before do
        obj.permissions_attributes = [{access: "edit", type: "person", name: "bob@example.com"}]
        obj.adminMetadata.downloader = ["Downloaders", "sally@example.com"]
      end

      it "should convert the legacy authorization to roles" do
        expect(subject.to_roles)
          .to eq(Roles::DetachedRoleSet.new(
                  [ Roles::Role.build(type: "Downloader", agent: "Downloaders", scope: "resource"),
                    Roles::Role.build(type: "Downloader", agent: "sally@example.com", scope: "resource"),
                    Roles::Role.build(type: "Editor", agent: "bob@example.com", scope: "resource") ]
                ))
      end

    end

  end
end
