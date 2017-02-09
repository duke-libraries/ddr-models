require 'spec_helper'

RSpec.describe Item, type: :model do

  it_behaves_like "a DDR model"
  it_behaves_like "it has an association", :belongs_to, :parent, :is_member_of_collection, "Collection"
  it_behaves_like "it has an association", :has_many, :children, :is_part_of, "Component"
  it_behaves_like "a non-collection model"
  it_behaves_like "a potentially publishable object"

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

end
