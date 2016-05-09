module Ddr::Models
  RSpec.describe Indexing do

    subject { obj.index_fields }

    describe "general indexing" do
      let(:obj) { FactoryGirl.build(:item) }

      let(:role1) { FactoryGirl.build(:role, :curator, :person, :resource) }
      let(:role2) { FactoryGirl.build(:role, :curator, :person, :policy) }
      let(:role3) { FactoryGirl.build(:role, :editor, :group, :policy) }
      let(:role4) { FactoryGirl.build(:role, :editor, :person, :policy) }

      before do
        obj.aspace_id = "aspace_dccea43034e1b8261e14cf999e86449d"
        obj.display_format = "Image"
        obj.doi = "http://doi.org/10.1000/182"
        obj.fcrepo3_pid = "duke:1"
        obj.license = "cc-by-nc-nd-40"
        obj.local_id = "foo"
        obj.permanent_id = "ark:/99999/fk4zzz"
        obj.permanent_url = "http://id.library.duke.edu/ark:/99999/fk4zzz"
        obj.roles.grant role1, role2, role3, role4
        obj.save
        obj.reload
      end

      its([Indexing::ACCESS_ROLE]) { is_expected.to eq(obj.roles.to_json) }
      its([Indexing::ASPACE_ID]) { is_expected.to eq("aspace_dccea43034e1b8261e14cf999e86449d") }
      its([Indexing::DISPLAY_FORMAT]) { is_expected.to eq("Image") }
      its([Indexing::DOI]) { is_expected.to eq("http://doi.org/10.1000/182") }
      its([Indexing::FCREPO3_PID]) { is_expected.to eq("duke:1") }
      its([Indexing::LICENSE]) { is_expected.to eq("cc-by-nc-nd-40") }
      its([Indexing::LOCAL_ID]) { is_expected.to eq("foo") }
      its([Indexing::PERMANENT_ID]) { is_expected.to eq("ark:/99999/fk4zzz") }
      its([Indexing::PERMANENT_URL]) {
        is_expected.to eq("http://id.library.duke.edu/ark:/99999/fk4zzz")
      }
      its([Indexing::POLICY_ROLE]) {
        is_expected.to contain_exactly(role2.agent, role3.agent, role4.agent)
      }
      its([Indexing::RESOURCE_ROLE]) { is_expected.to contain_exactly(role1.agent) }

      describe "when it doesn't have a permanent id" do
        before {
          obj.permanent_id = nil
        }
        its([Indexing::UNIQUE_ID]) { is_expected.to eq([obj.id]) }
      end
    end

    describe "content-bearing object indexing" do
      let(:obj) { FactoryGirl.create(:component) }
      let!(:create_date) { DateTime.parse("2016-01-22T21:50:33Z") }
      before {
        allow(obj.content).to receive(:create_date) { create_date }
      }

      its([Indexing::CONTENT_CREATE_DATE]) { is_expected.to eq "2016-01-22T21:50:33Z" }
      its([Indexing::ATTACHED_FILES_HAVING_CONTENT]) {
        is_expected.to eq([:content])
      }
    end

  end
end
