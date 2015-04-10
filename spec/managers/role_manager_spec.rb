module Ddr::Managers
  RSpec.describe RoleManager do

    let(:obj) { FactoryGirl.build(:collection) }

    subject { obj.roles }

    describe "granted roles" do
      it "should return the access roles defined on the datastream" do
        expect(obj.adminMetadata).to receive(:access_role) { [] }
        subject.granted
      end
    end

    describe "#index_fields" do
      let(:roles) do
        [{ type: :curator, person: "bob@example.com", scope: :resource },
         { type: :curator, person: "sue@example.com", scope: :policy },
         { type: :editor, group: "Editors", scope: :policy },
         { type: :editor, person: "jane@example.com", scope: :policy }]
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
      let(:contributor_role) { Ddr::Auth::Roles::Contributor.build(group: "Contributors", scope: :resource) }
      let(:downloader_role) { Ddr::Auth::Roles::Downloader.build(group: "Downloaders", scope: :resource) }
      let(:curator_role) { Ddr::Auth::Roles::Curator.build(person: "bob@example.com", scope: :policy) }
      let(:agents) { [contributor_role.get_agent, downloader_role.get_agent, curator_role.get_agent] }
      before do
        subject.grant(contributor_role, downloader_role, curator_role)
      end
      describe "#permissions_in_scope_for_agents" do
        it "should return the permissions granted in scope to any of the agents" do
          expect(subject.permissions_in_scope_for_agents(:resource, agents)).to match_array([:read, :add_children, :download])
          expect(subject.permissions_in_scope_for_agents(:policy, agents)).to match_array([:read, :add_children, :download, :edit, :replace, :arrange, :grant])
        end
      end
    end
    
  end
end
