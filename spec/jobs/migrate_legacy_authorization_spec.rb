module Ddr::Jobs
  RSpec.describe MigrateLegacyAuthorization do

    let(:obj) { FactoryGirl.build(:collection) }

    before do
      @deprecation_behavior = Deprecation.default_deprecation_behavior
      Deprecation.default_deprecation_behavior = :silence
      obj.permissions_attributes = [{access: "edit", type: "person", name: "bob@example.com"}]
      obj.adminMetadata.downloader = ["Downloaders", "sally@example.com"]
      obj.default_permissions = [{access: "edit", type: "group", name: "Editors"},
                                 {access: "discover", type: "group", name: "public"},
                                 {access: "read", type: "group", name: "registered"}]
      obj.save!
    end

    after do
      Deprecation.default_deprecation_behavior = @deprecation_behavior
    end

    it "should migrate the authorization data to roles" do
      Resque.enqueue(described_class, obj.pid)
      obj.reload
      expect(obj.legacy_authorization).to be_clear
      expect(obj.roles)
        .to eq(Ddr::Auth::Roles::DetachedRoleSet.new(
                [ Ddr::Auth::Roles::Role.build(type: "Curator", agent: "Editors", scope: "policy"),
                  Ddr::Auth::Roles::Role.build(type: "Viewer", agent: "public", scope: "policy"),
                  Ddr::Auth::Roles::Role.build(type: "Viewer", agent: "registered", scope: "policy"),
                  Ddr::Auth::Roles::Role.build(type: "Editor", agent: "bob@example.com", scope: "resource"),
                  Ddr::Auth::Roles::Role.build(type: "Downloader", agent: "Downloaders", scope: "resource"),
                  Ddr::Auth::Roles::Role.build(type: "Downloader", agent: "sally@example.com", scope: "resource")
                ]
              ))
      event = obj.update_events.last
      expect(event).to be_success
      expect(event.summary).to eq("Legacy authorization data migrated to roles")
      expect(event.detail).to match(/LEGACY AUTHORIZATION DATA/)
      expect(event.detail).to match(/ROLES/)
    end

  end
end
