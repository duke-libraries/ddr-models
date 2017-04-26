RSpec.describe Collection, type: :model do

  subject { described_class.new(title: ["Test Collection"], admin_set: "foo") }

  before { allow(Ddr::Models::AdminSet).to receive(:find_by_code) { test_admin_set } }

  it_behaves_like "a DDR model"
  it_behaves_like "it has an association", :has_many, :children, :is_member_of_collection, "Item"
  it_behaves_like "it has an association", :has_many, :targets, :is_external_target_for, "Target"
  it_behaves_like "a publishable object"
  it_behaves_like "an object that cannot be streamable"

  describe "admin set" do
    before do
      allow(Ddr::Models::AdminSet).to receive(:find_by_code) { test_admin_set }
      subject.admin_set = test_admin_set.code
    end
    it "indexes the admin set title" do
      expect(subject.to_solr[Ddr::Index::Fields::ADMIN_SET_TITLE]).to eq(test_admin_set.title)
    end
  end

  describe "title" do
    it "indexes the collection title" do
      expect(subject.to_solr[Ddr::Index::Fields::COLLECTION_TITLE]).to eq("Test Collection")
    end
  end

  describe "#components_from_solr" do
    subject { Collection.new(pid: 'test:1') }
    before do
      allow_any_instance_of(Component).to receive(:collection_uri).and_return(subject.internal_uri)
    end
    it "returns the correct component(s)" do
      component = Component.create
      docs = subject.components_from_solr
      expect(docs.size).to eq(1)
      expect(docs.first.id).to eq(component.pid)
    end
  end

  describe "validation" do
    before do
      subject.title = nil
    end
    it "requires a title" do
      expect(subject).to_not be_valid
      expect(subject.errors.messages).to have_key(:title)
    end
  end

  describe "creation" do
    before { subject.save! }
    it "is governed by itself" do
      expect(subject.admin_policy).to eq(subject)
    end
  end

  describe "roles granted to creator" do
    let(:user) { FactoryGirl.build(:user) }
    before { subject.grant_roles_to_creator(user) }
    its(:roles) { is_expected.to include(Ddr::Auth::Roles::Role.build(type: "Curator", agent: user, scope: "policy")) }
  end

  describe "default roles granted" do
    describe "and the metadata managers group is set" do
      before do
        allow(Ddr::Auth).to receive(:metadata_managers_group) { "metadata_managers" }
        subject.save!
      end
      it "includes the MetadataEditor role in policy scope for the Metadata Managers group" do
        expect(subject.roles.to_a).to eq([Ddr::Auth::Roles::Role.build(type: "MetadataEditor", agent: "metadata_managers", scope: "policy")])
      end
    end
    describe "and the metadata managers group is not set" do
      before do
        allow(Ddr::Auth).to receive(:metadata_managers_group) { nil }
        subject.save!
      end
      its(:roles) { is_expected.to be_empty }
    end
  end

  describe "attachments" do
    its(:can_have_attachments?) { is_expected.to be true }
    it { is_expected.not_to have_attachments }
    specify {
      subject.attachments << Attachment.new
      expect(subject).to have_attachments
    }
  end

  describe "content" do
    its(:can_have_content?) { is_expected.to be false }
    it { is_expected.to_not have_content }
  end

  describe "children" do
    its(:can_have_children?) { is_expected.to be true }
    it { is_expected.to_not have_children }
    specify {
      subject.children << Item.new
      expect(subject).to have_children
    }
  end

end
