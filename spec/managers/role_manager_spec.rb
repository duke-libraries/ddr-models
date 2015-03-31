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
        [{ type: :owner, person: "bob", scope: :resource },
         { type: :curator, person: "sue", scope: :policy },
         { type: :editor, group: "Editors", scope: :policy },
         { type: :editor, person: "jane", scope: :policy }]
      end
      before { subject.grant *roles }
      it "should return the index fields" do
        expect(subject.index_fields).to eq({"resource_owner_role_ssim" => ["bob"],
                                             "policy_curator_role_ssim" => ["sue"],
                                             "policy_editor_role_ssim" => ["Editors", "jane"],
                                             "policy_role_sim" => ["sue", "Editors", "jane"],
                                             "resource_role_sim" => ["bob"]})
      end
    end

    describe "permissions" do
      before do
        subject.grant({type: :contributor, group: "Contributors", scope: :resource},
                      {type: :downloader, group: "Downloaders", scope: :resource},
                      {type: :curator, person: "bob", scope: :policy})
      end
      describe "#permissions_in_scope_for_agents" do
        it "should return the permissions granted in scope to any of the agents" do
          expect(subject.permissions_in_scope_for_agents(:resource, [Ddr::Auth::Group.build("Contributors"), Ddr::Auth::Group.build("Downloaders"), Ddr::Auth::Person.build("bob")])).to match_array([:read, :add_children, :download])
          expect(subject.permissions_in_scope_for_agents(:policy, [Ddr::Auth::Group.build("Contributors"), Ddr::Auth::Group.build("Downloaders"), Ddr::Auth::Person.build("bob")])).to match_array([:read, :add_children, :download, :edit, :upload, :arrange, :grant])
        end
      end
    end
    
  end
end
