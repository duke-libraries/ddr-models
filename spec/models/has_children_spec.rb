module Ddr::Models
  RSpec.describe HasChildren do

    subject { FactoryGirl.create(:item) }

    describe "#first_child" do
      describe "when the object has no children" do
        it "should return nil" do
          expect(subject.first_child).to be_nil
        end
      end
      describe "when the object has children" do
        let(:child1) { FactoryGirl.create(:component) }
        let(:child2) { FactoryGirl.create(:component) }
        let(:child3) { FactoryGirl.create(:component) }
        before do
          child1.local_id = "test002"
          child1.save!
          child2.local_id = "test001"
          child2.save!
          child3.local_id = "test003"
          child3.save!
          subject.children << child1
          subject.children << child2
          subject.children << child3
          subject.save!
        end
        describe "when the object has structural metadata" do
          before do
            struct_map = <<-EOS
              <mets xmlns="http://www.loc.gov/METS/" xmlns:xlink="http://www.w3.org/1999/xlink">
                <structMap TYPE="default">
                  <div ORDER="1">
                    <fptr CONTENTIDS="#{child3.id}" />
                  </div>
                  <div ORDER="2">
                    <fptr CONTENTIDS="#{child2.id}" />
                  </div>
                  <div ORDER="3">
                    <fptr CONTENTIDS="#{child1.id}" />
                  </div>
                </structMap>
              </mets>
            EOS
            subject.structMetadata.content = struct_map
            subject.save!
          end
          it "should return the first child based on structural metadata order" do
            expect(subject.first_child).to eq(child3)
          end
        end
        describe "when the object does not have structural metadata" do

          it "should return the first child as sorted by local ID" do
            expect(subject.first_child).to eq(child2)
          end
        end
      end
    end

  end
end
