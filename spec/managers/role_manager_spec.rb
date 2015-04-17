module Ddr::Managers
  RSpec.describe RoleManager do

    let(:obj) { FactoryGirl.build(:collection) }

    subject { described_class.new(obj) }

    describe "legacy roles" do
      describe "#downloader" do
        before do
          obj.adminMetadata.downloader = "bob@example.com"
        end
        it "should return the downloader property of the adminMetadata datastream" do
          expect(subject.downloader).to eq(["bob@example.com"])
        end
      end
    end

    describe "granted roles" do
      it "should return the access roles defined on the datastream" do
        expect(obj.adminMetadata).to receive(:access_role) { [] }
        subject.granted
      end
    end

    describe "#index_fields" do
      let(:roles) do
        [{ type: "Curator", agent: "bob@example.com", scope: "resource" },
         { type: "Curator", agent: "sue@example.com", scope: "policy" },
         { type: "Editor", agent: "Editors", scope: "policy" },
         { type: "Editor", agent: "jane@example.com", scope: "policy" }]
      end
      before { subject.grant *roles }
      it "should return the index fields" do
        expect(subject.index_fields).to eq({"resource_curator_role_ssim" => ["bob@example.com"],
                                             "policy_curator_role_ssim" => ["sue@example.com"],
                                             "policy_editor_role_ssim" => ["Editors", "jane@example.com"],
                                             "policy_role_sim" => ["sue@example.com", "Editors", "jane@example.com"],
                                             "resource_role_sim" => ["bob@example.com"]})
      end
    end

    describe "permissions" do
      let(:contributor_role) { Ddr::Auth::Roles::Role.build(type: "Contributor", 
                                                            agent: "Contributors", 
                                                            scope: "resource") }
      let(:downloader_role) { Ddr::Auth::Roles::Role.build(type: "Downloader", 
                                                           agent: "Downloaders", 
                                                           scope: "resource") }
      let(:curator_role) { Ddr::Auth::Roles::Role.build(type: "Curator", 
                                                        agent: "bob@example.com", 
                                                        scope: "policy") }
      let(:agents) { [contributor_role.agent.first, downloader_role.agent.first, curator_role.agent.first] }
      before do
        subject.grant(contributor_role, downloader_role, curator_role)
      end
      describe "#permissions_in_scope_for_agents" do
        it "should return the permissions granted in scope to any of the agents" do
          expect(subject.permissions_in_scope_for_agents("resource", agents)).to match_array([:read, :add_children, :download])
          expect(subject.permissions_in_scope_for_agents("policy", agents)).to match_array([:read, :add_children, :download, :edit, :replace, :arrange, :grant])
        end
      end
    end
    
  end
end
