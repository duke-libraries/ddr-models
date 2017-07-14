RSpec.describe Collection, type: :model do

  subject { described_class.new(title: ["Test Collection"], admin_set: "foo") }

  it_behaves_like "a DDR model"
  it_behaves_like "it has an association", :has_many, :children, :is_member_of_collection, "Item"
  it_behaves_like "it has an association", :has_many, :targets, :is_external_target_for, "Target"
  it_behaves_like "a publishable object"
  it_behaves_like "an object that cannot be streamable"

  describe "admin set" do
    before do
      subject.admin_set = "foo"
    end
    it "indexes the admin set title" do
      expect(subject.to_solr[Ddr::Index::Fields::ADMIN_SET_TITLE]).to eq("Foo Admin Set")
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

  describe "#default_structure" do
    before do
      allow(SecureRandom).to receive(:uuid).and_return("abc-def", "ghi-jkl", "mno-pqr", "stu-vwx", "yza-bcd", "efg-hij")
    end
    describe "when the collection has no items" do
      it "should be nil" do
        expect(subject.default_structure).to be_nil
      end
    end
    describe "when the collection has items" do
      let(:item1) { FactoryGirl.create(:item) }
      let(:item2) { FactoryGirl.create(:item) }
      before do
        item1.local_id = "test002"
        item1.permanent_id = "ark:/99999/fk4aaa"
        item1.save!
        item2.local_id = "test001"
        item2.permanent_id = "ark:/99999/fk4bbb"
        item2.save!
        subject.children << item1
        subject.children << item2
        subject.save!
      end
      after do
        item1.destroy
        item2.destroy
      end
      describe "without nested paths" do
        let(:expected) do
          xml = <<-EOS
            <mets xmlns="http://www.loc.gov/METS/" xmlns:xlink="http://www.w3.org/1999/xlink">
              <metsHdr>
                <agent ROLE="#{Ddr::Models::Structures::Agent::ROLE_CREATOR}">
                  <name>#{Ddr::Models::Structures::Agent::NAME_REPOSITORY_DEFAULT}</name>
                </agent>
              </metsHdr>
              <structMap TYPE="#{Ddr::Models::Structure::TYPE_DEFAULT}">
                <div ORDER="1">
                  <mptr LOCTYPE="ARK" xlink:href="ark:/99999/fk4bbb" />
                </div>
                <div ORDER="2">
                  <mptr LOCTYPE="ARK" xlink:href="ark:/99999/fk4aaa" />
                </div>
              </structMap>
            </mets>
          EOS
          xml
        end
        it "should be the appropriate structure" do
          expect(subject.default_structure.to_xml).to be_equivalent_to(expected)
        end
      end
      describe "with nested paths" do
        let(:item3) { FactoryGirl.create(:item) }
        let(:item4) { FactoryGirl.create(:item) }
        let(:item5) { FactoryGirl.create(:item) }
        let(:item6) { FactoryGirl.create(:item) }
        let(:expected) do
          xml = <<-EOS
            <mets xmlns="http://www.loc.gov/METS/" xmlns:xlink="http://www.w3.org/1999/xlink">
              <metsHdr>
                <agent ROLE="#{Ddr::Models::Structures::Agent::ROLE_CREATOR}">
                  <name>#{Ddr::Models::Structures::Agent::NAME_REPOSITORY_DEFAULT}</name>
                </agent>
              </metsHdr>
              <structMap TYPE="#{Ddr::Models::Structure::TYPE_DEFAULT}">
                <div LABEL="foo" ORDER="1" TYPE="Directory">
                  <div LABEL="b&amp;apos;a&amp;quot;r&amp;quot;" ORDER="1" TYPE="Directory">
                    <div ORDER="1">
                      <mptr LOCTYPE="ARK" xlink:href="ark:/99999/fk4aaa" />
                    </div>
                    <div ORDER="2">
                      <mptr LOCTYPE="ARK" xlink:href="ark:/99999/fk4bbb" />
                    </div>
                  </div>
                  <div LABEL="baz" ORDER="2" TYPE="Directory">
                    <div ORDER="1">
                      <mptr LOCTYPE="ARK" xlink:href="ark:/99999/fk4ddd" />
                    </div>
                    <div ORDER="2">
                      <mptr LOCTYPE="ARK" xlink:href="ark:/99999/fk4ccc" />
                    </div>
                  </div>
                  <div ORDER="3">
                    <mptr LOCTYPE="ARK" xlink:href="ark:/99999/fk4fff" />
                  </div>
                  <div ORDER="4">
                    <mptr LOCTYPE="ARK" xlink:href="ark:/99999/fk4eee" />
                  </div>
                </div>
              </structMap>
            </mets>
          EOS
          xml
        end
        before do
          item3.local_id = "test003"
          item3.permanent_id = "ark:/99999/fk4ccc"
          item3.save!
          item4.local_id = "test004"
          item4.permanent_id = "ark:/99999/fk4ddd"
          item4.save!
          item5.local_id = "test005"
          item5.permanent_id = "ark:/99999/fk4eee"
          item5.save!
          item6.local_id = "test006"
          item6.permanent_id = "ark:/99999/fk4fff"
          item6.save!
          subject.children << item3
          subject.children << item4
          subject.children << item5
          subject.children << item6
          subject.save!
          item1.nested_path = %Q[foo/b'a"r"/a.doc]
          item1.save!
          item2.nested_path = %Q[foo/b'a"r"/b.txt]
          item2.save!
          item3.nested_path = %Q[foo/baz/d.pdf]
          item3.save!
          item4.nested_path = %Q[foo/baz/c.txt]
          item4.save!
          item5.nested_path = %Q[foo/f.doc]
          item5.save!
          item6.nested_path = %Q[foo/e.pdf]
          item6.save!
        end
        after do
          item3.destroy
          item4.destroy
          item5.destroy
          item6.destroy
        end
        it "should be the appropriate structure" do
          expect(subject.default_structure.to_xml).to be_equivalent_to(expected)
        end
      end
    end
  end

end
