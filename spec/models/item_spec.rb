require 'spec_helper'

RSpec.describe Item, type: :model do

  it_behaves_like "a DDR model"
  it_behaves_like "a non-collection model"
  it_behaves_like "a potentially publishable object"

  describe ".in_collection scope" do
    let(:coll) { FactoryGirl.create(:collection) }
    let(:item1) { FactoryGirl.create(:item) }
    let(:item2) { FactoryGirl.build(:item) }
    before {
      item2.parent = coll
      item2.local_id = "item2"
      item2.save
    }
    specify {
      expect(Item.in_collection(coll)).not_to include(item1)
      expect(Item.in_collection(coll)).to include(item2)
    }
    describe "chainability with .having_local_id" do
      specify {
        expect(Item.in_collection(coll).having_local_id("item2")).to include(item2)
        expect(Item.in_collection(coll).having_local_id("item1")).not_to include(item2)
      }
    end
  end

  describe "indexing text" do
    let(:children) { FactoryGirl.build_list(:component, 5) }

    let(:text1) { fixture_file_upload('extractedText1.txt', 'text/plain') }
    let(:text2) { fixture_file_upload('extractedText2.txt', 'text/plain') }
    let(:text3) { fixture_file_upload('extractedText3.txt', 'text/plain') }

    before {
      children[0].extractedText.content = text1
      children[0].save
      children[1].extractedText.content = text2
      children[1].save
      children[2].extractedText.content = text3
      children[2].save
      subject.children = children
      subject.save
    }

    it "indexes the combined text of its children" do
      expect(subject.index_fields[Ddr::Index::Fields::ALL_TEXT]).to contain_exactly(text1.read, text2.read, text3.read)
    end
  end

end
