require 'spec_helper'

RSpec.describe Component, type: :model, components: true do

  it_behaves_like "a DDR model"
  it_behaves_like "an object that can have content"
  it_behaves_like "it has an association", :belongs_to, :parent, :is_part_of, "Item"
  it_behaves_like "it has an association", :belongs_to, :target, :has_external_target, "Target"
  it_behaves_like "a non-collection model"
  it_behaves_like "a potentially publishable object"

  describe "indexing" do
    subject { FactoryGirl.build(:component) }
    before do
      allow(subject).to receive(:collection) { Collection.new(pid: "test:1") }
    end
    its(:index_fields) { is_expected.to include(Ddr::Index::Fields::COLLECTION_URI => "info:fedora/test:1") }
  end

  describe "extracted text" do
    let(:parent) { FactoryGirl.create(:item) }
    describe "when the child is not already associated with the parent" do
      before {
        subject.extractedText.content = fixture_file_upload('extractedText1.txt')
        subject.save
        subject.reload
      }
      it "updates the parent index when associated" do
        expect(subject).to receive(:index_parent)
        subject.parent = parent
        subject.save
      end
    end
    describe "when the child is already associated with the parent" do
      before {
        subject.parent = parent
        subject.save
      }
      describe "when there is no extracted text" do
        describe "and none is added" do
          it "does not trigger an index update on the parent" do
            expect(subject).not_to receive(:index_parent)
            subject.save
          end
        end
        describe "and extracted text is added" do
          it "triggers an index update on the parent" do
            expect(subject).to receive(:index_parent)
            subject.extractedText.content = fixture_file_upload('extractedText1.txt')
            subject.save
          end
        end
      end
      describe "when extracted text exists" do
        before {
          subject.extractedText.content = fixture_file_upload('extractedText1.txt')
          subject.save
          subject.reload
        }
        describe "and is removed" do
          it "triggers an index update on the parent" do
            pending "Deleting a datastream does not mark the content as changed"
            expect(subject).to receive(:index_parent)
            subject.extractedText.delete
            subject.save
          end
        end
        describe "and doesn't change" do
          it "triggers an index update on the parent" do
            expect(subject).to receive(:index_parent)
            subject.save
          end
        end
        describe "and changes" do
          it "triggers an index update on the parent" do
            expect(subject).to receive(:index_parent)
            subject.extractedText.content = fixture_file_upload('extractedText2.txt')
            subject.save
          end
        end
      end
    end
  end
end
