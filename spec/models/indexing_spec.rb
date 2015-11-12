module Ddr::Models
  RSpec.describe Indexing do

    let(:obj) { FactoryGirl.create(:item) }

    let(:role1) { FactoryGirl.build(:role, :curator, :person, :resource) }
    let(:role2) { FactoryGirl.build(:role, :curator, :person, :policy) }
    let(:role3) { FactoryGirl.build(:role, :editor, :group, :policy) }
    let(:role4) { FactoryGirl.build(:role, :editor, :person, :policy) }

    subject { obj.index_fields }

    before do
      obj.license = "cc-by-nc-nd-40"
      obj.local_id = "foo"
      obj.doi << "http://doi.org/10.1000/182"
      obj.permanent_id = "ark:/99999/fk4zzz"
      obj.permanent_url = "http://id.library.duke.edu/ark:/99999/fk4zzz"
      obj.display_format = "Image"
      obj.roles.grant role1, role2, role3, role4
    end

    its([Indexing::LICENSE]) { is_expected.to eq("cc-by-nc-nd-40") }
    its([Indexing::LOCAL_ID]) { is_expected.to eq("foo") }
    its([Indexing::DOI]) { is_expected.to eq(["http://doi.org/10.1000/182"]) }
    its([Indexing::PERMANENT_ID]) { is_expected.to eq("ark:/99999/fk4zzz") }
    its([Indexing::PERMANENT_URL]) { is_expected.to eq("http://id.library.duke.edu/ark:/99999/fk4zzz") }
    its([Indexing::DISPLAY_FORMAT]) { is_expected.to eq("Image") }
    its([Indexing::ACCESS_ROLE]) { is_expected.to eq(obj.roles.to_json) }
    its([Indexing::POLICY_ROLE]) { is_expected.to contain_exactly(role2.agent, role3.agent, role4.agent) }
    its([Indexing::RESOURCE_ROLE]) { is_expected.to contain_exactly(role1.agent) }

  end
end
