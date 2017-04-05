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

    describe "#default_structure" do
      describe "when the object has no children" do
        it "should be nil" do
          expect(subject.default_structure).to be_nil
        end
      end
      describe "when the object has children" do
        let(:child1) { FactoryGirl.create(:item) }
        let(:child2) { FactoryGirl.create(:item) }
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
        before do
          child1.local_id = "test002"
          child1.permanent_id = "ark:/99999/fk4aaa"
          child1.save!
          child2.local_id = "test001"
          child2.permanent_id = "ark:/99999/fk4bbb"
          child2.save!
          subject.children << child1
          subject.children << child2
          subject.save!
          allow(SecureRandom).to receive(:uuid).and_return("abc-def", "ghi-jkl")
        end
        after do
          child1.destroy
          child2.destroy
        end
        it "should be the appropriate structure" do
          expect(subject.default_structure.to_xml).to be_equivalent_to(expected)
        end
      end
    end

  end
end
