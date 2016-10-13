RSpec.shared_examples "a non-collection model" do
  describe "roles granted to creator" do
    subject { described_class.new }
    let(:user) { FactoryGirl.build(:user) }
    before { subject.grant_roles_to_creator(user) }
    it "includes the Editor role in resource scope" do
      expect(subject.roles.to_a).to eq([Ddr::Auth::Roles::Role.build(type: "Editor", agent: user.agent, scope: "resource")])
    end
  end

  describe "admin set" do
    subject { described_class.new }
    let(:collection) { FactoryGirl.build(:collection) }
    let(:admin_set) { Ddr::Models::AdminSet.new(code: "foobar", title: "FooBar") }
    before {
      allow(Ddr::Models::AdminSet).to receive(:find_by_code).with("foobar") { admin_set }
      collection.admin_set = "foobar"
      collection.save!
      subject.admin_policy = collection
    }
    it "indexes the admin set title" do
      expect(subject.to_solr[Ddr::Index::Fields::ADMIN_SET_TITLE]).to eq("FooBar")
    end
  end
end
