module Ddr::Auth
  module Roles
    RSpec.describe PropertyRoleSet, roles: true do

      subject { described_class.new(wrapped) }
      
      let(:wrapped_class) do
        Class.new(ActiveTriples::Resource) do
          property :role, predicate: Ddr::Vocab::Roles.hasRole
        end
      end

      let(:wrapped) { wrapped_class.new.role }

      it_behaves_like "a role set"

      describe "equality" do
        let(:role1) { FactoryGirl.build(:role, :curator, :person, :policy) }
        let(:role2) { FactoryGirl.build(:role, :editor, :group, :resource) }        
        let(:other) { described_class.new(wrapped_class.new.role) }
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
