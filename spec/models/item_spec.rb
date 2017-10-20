RSpec.describe Item, type: :model do

  it_behaves_like "a DDR model"
  it_behaves_like "it has an association", :belongs_to, :parent, :is_member_of_collection, "Collection"
  it_behaves_like "it has an association", :has_many, :children, :is_part_of, "Component"
  it_behaves_like "a non-collection model"
  it_behaves_like "a potentially publishable object"
  it_behaves_like "an object that cannot be streamable"

  describe "indexing text" do
    let(:children) { FactoryGirl.build_list(:component, 5) }

    let(:text1) { fixture_file_upload('extractedText1.txt', 'text/plain') }
    let(:text2) { fixture_file_upload('extractedText2.txt', 'text/plain') }
    let(:text3) { fixture_file_upload('extractedText3.txt', 'text/plain') }

    before {
      children[0].extractedText.content = text1
      children[0].save!
      children[1].extractedText.content = text2
      children[1].save!
      children[2].extractedText.content = text3
      children[2].save!
      children[3].save!
      children[4].save!
      subject.children = children
      subject.save!
    }

    it "indexes the combined text of its children" do
      expect(subject.index_fields[Ddr::Index::Fields::ALL_TEXT]).to contain_exactly(File.read(text1.path), File.read(text2.path), File.read(text3.path))
    end
  end

  describe "content" do
    its(:can_have_content?) { is_expected.to be false }
    it { is_expected.to_not have_content }
  end

  describe "children" do
    its(:can_have_children?) { is_expected.to be true }
    it { is_expected.to_not have_children }
    specify {
      subject.children << Component.new
      expect(subject).to have_children
    }
  end

  describe "#default_structure" do
    describe "when the item has no components" do
      let(:expected) do
        xml = <<-EOS
            <mets xmlns="http://www.loc.gov/METS/" xmlns:xlink="http://www.w3.org/1999/xlink">
              <metsHdr>
                <agent ROLE="#{Ddr::Models::Structures::Agent::ROLE_CREATOR}">
                  <name>#{Ddr::Models::Structures::Agent::NAME_REPOSITORY_DEFAULT}</name>
                </agent>
              </metsHdr>
              <structMap TYPE="#{Ddr::Models::Structure::TYPE_DEFAULT}" />
            </mets>
        EOS
        xml
      end
      it "should be the appropriate structure" do
        expect(subject.default_structure.to_xml).to be_equivalent_to(expected)
      end
    end
    describe "when the item has components" do
      let(:comp1) { Component.new }
      let(:comp2) { Component.new }
      let(:comp3) { Component.new }
      let(:comp4) { Component.new }
      let(:expected) do
        xml = <<-EOS
            <mets xmlns="http://www.loc.gov/METS/" xmlns:xlink="http://www.w3.org/1999/xlink">
              <metsHdr>
                <agent ROLE="#{Ddr::Models::Structures::Agent::ROLE_CREATOR}">
                  <name>#{Ddr::Models::Structures::Agent::NAME_REPOSITORY_DEFAULT}</name>
                </agent>
              </metsHdr>
              <structMap TYPE="#{Ddr::Models::Structure::TYPE_DEFAULT}">
                <div TYPE="Documents">
                  <div ORDER="1">
                    <mptr LOCTYPE="ARK" xlink:href="ark:/99999/fk4ccc" />
                  </div>
                </div>
                <div TYPE="Images">
                  <div ORDER="1">
                    <mptr LOCTYPE="ARK" xlink:href="ark:/99999/fk4bbb" />
                  </div>
                  <div ORDER="2">
                    <mptr LOCTYPE="ARK" xlink:href="ark:/99999/fk4aaa" />
                  </div>
                </div>
                <div TYPE="Other">
                  <div ORDER="1">
                    <mptr LOCTYPE="ARK" xlink:href="ark:/99999/fk4ddd" />
                  </div>
                </div>
              </structMap>
            </mets>
        EOS
        xml
      end
      before do
        comp1.local_id = "test001002"
        comp1.permanent_id = "ark:/99999/fk4aaa"
        comp1.upload fixture_file_upload("imageB.tif", "image/tiff")
        comp1.save!
        comp2.local_id = "test001001"
        comp2.permanent_id = "ark:/99999/fk4bbb"
        comp2.upload fixture_file_upload("imageA.tif", "image/tiff")
        comp2.save!
        comp3.local_id = "test001"
        comp3.permanent_id = "ark:/99999/fk4ccc"
        comp3.upload fixture_file_upload("sample.pdf", "application/pdf")
        comp3.save!
        comp4.local_id = "test123"
        comp4.permanent_id = "ark:/99999/fk4ddd"
        comp4.upload fixture_file_upload("abcd1234.vtt", "application/octet-stream")
        comp4.save!
        subject.children << comp1
        subject.children << comp2
        subject.children << comp3
        subject.children << comp4
        subject.save!
      end
      after do
        comp1.destroy
        comp2.destroy
        comp3.destroy
      end
      it "should be the appropriate structure" do
        expect(subject.default_structure.to_xml).to be_equivalent_to(expected)
      end
    end
  end

end
