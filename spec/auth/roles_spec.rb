module Ddr::Auth
  RSpec.describe Roles do
    describe ".get_role_class" do
      it "should return the class for the role type" do
        expect(Roles.get_role_class(:curator)).to eq(Roles::Curator)
        expect(Roles.get_role_class(:editor)).to eq(Roles::Editor)
        expect(Roles.get_role_class(:contributor)).to eq(Roles::Contributor)
        expect(Roles.get_role_class(:metadata_editor)).to eq(Roles::MetadataEditor)
        expect(Roles.get_role_class(:downloader)).to eq(Roles::Downloader)
        expect(Roles.get_role_class(:viewer)).to eq(Roles::Viewer)
      end
    end
    describe ".build_role" do
      subject {  Roles.build_role(type: :curator, person: "bob@example.com", scope: "resource") }
      it { is_expected.to be_a(Roles::Curator) }
      its(:agent_name) { is_expected.to eq("bob@example.com") }
      it "should have 'resource' scope" do
        expect(subject.scope.first).to eq("resource")
      end
      it "should have a Person agent" do
        expect(subject.agent.first).to be_a(Person)
      end
    end
  end
end
