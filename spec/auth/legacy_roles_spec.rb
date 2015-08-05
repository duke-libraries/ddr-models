module Ddr::Auth
  RSpec.describe LegacyRoles do

    subject { described_class.new(obj) }

    let(:obj) { FactoryGirl.build(:component) }

    before do
      @deprecation_behavior = Deprecation.default_deprecation_behavior
      Deprecation.default_deprecation_behavior = :silence
      obj.adminMetadata.downloader = ["bob@example.com", "Downloaders"]
    end

    after do
      Deprecation.default_deprecation_behavior = @deprecation_behavior
    end

    it "should convert the legacy roles to new roles" do
      expect(subject.to_roles)
        .to eq(Roles::DetachedRoleSet.new(
                [ Roles::Role.build(type: "Downloader", agent: "Downloaders", scope: "resource"),
                  Roles::Role.build(type: "Downloader", agent: "bob@example.com", scope: "resource")
                ]
              ))
    end

    it "should clear the legacy roles" do
      expect { subject.clear }.to change(obj.adminMetadata.downloader, :empty?).from(false).to(true)
    end

  end
end
