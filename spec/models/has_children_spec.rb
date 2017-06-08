module Ddr::Models
  RSpec.describe HasChildren do

    subject { FactoryGirl.create(:collection) }

    describe "#first_child" do
      describe "when the object has no children" do
        it "should return nil" do
          expect(subject.first_child).to be_nil
        end
      end
      describe "when the object has children" do
        let(:child1) { FactoryGirl.create(:item) }
        let(:child2) { FactoryGirl.create(:item) }
        before do
          child1.local_id = "test002"
          child1.save!
          child2.local_id = "test001"
          child2.save!
          subject.children << child1
          subject.children << child2
          subject.save!
        end
        it "should return the first child as sorted by local ID" do
          expect(subject.first_child).to eq(child2)
        end
      end
    end

  end
end
