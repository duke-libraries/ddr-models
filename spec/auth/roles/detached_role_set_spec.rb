module Ddr::Auth
  module Roles
    RSpec.describe DetachedRoleSet do

      subject { described_class.new(wrapped) }
      
      let(:wrapped) { Set.new }

      it_behaves_like "a role set"

      describe "deserialization" do
        let(:role1) { {type: "Editor", agent: "bob@example.com", scope: "resource"} }
        let(:role2) { {type: "Curator", agent: "sue@example.com", scope: "policy"} }

        before { subject.grant role1, role2 }
        
        it "should deserialize to an equalivalent role set" do
          expect(described_class.deserialize(subject.serialize)).to eq(subject)
        end

        it "should load JSON data" do
          expect(described_class.from_json("[{\"role_type\":[\"Editor\"],\"agent\":[\"bob@example.com\"],\"scope\":[\"resource\"]},{\"role_type\":[\"Curator\"],\"agent\":[\"sue@example.com\"],\"scope\":[\"policy\"]}]")).to eq(subject)
        end
      end

      describe "conversion to a plain Array" do
        let(:role1) { FactoryGirl.build(:role, :curator, :person, :policy) }
        let(:role2) { FactoryGirl.build(:role, :editor, :group, :resource) }
        before { subject.grant role1, role2 }
        its(:to_a) { should eq([role1, role2]) }
      end

      describe "equality" do
        let(:role1) { FactoryGirl.build(:role, :curator, :person, :policy) }
        let(:role2) { FactoryGirl.build(:role, :editor, :group, :resource) }        
        let(:other) { described_class.new(Array.new) }
        before do
          subject.grant role1, role2
          other.grant role2, role1
        end
        it "should be equal to another role set if it has the same roles, regardless of order" do
          expect(subject).to eq(other)
        end
      end

    end
    
  end
end

