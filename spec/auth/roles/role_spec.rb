module Ddr::Auth
  module Roles
    RSpec.describe Role do

      before do
        class Good < Role
          configure type: RDF::URI("http://example.com/Good")
          has_permission :read
        end
        class Better < Role
          configure type: RDF::URI("http://example.com/Better")
          has_permission :read, :download
        end
        class Best < Role
          configure type: RDF::URI("http://example.com/Best")
          has_permission :read, :download, :edit
        end
      end

      after do
        Roles.send(:remove_const, :Good)
        Roles.send(:remove_const, :Better)
        Roles.send(:remove_const, :Best)
      end

      describe "class methods" do
        describe ".role_type" do
          it "should return the role type for the role" do
            expect(Good.role_type).to eq(:good)
          end
        end
        describe ".build" do
          it "should return a role instance" do
            expect(Good.build(person: "bob", scope: :resource)).to be_a(Good)
          end
        end
        describe ".get_scope"
      end

      describe "isomorphism" do
        let(:role1) { Good.build(person: "bob", scope: :resource) }
        describe "two roles of the same type that have the same agent and scope" do
          let(:role2) { Good.build(person: "bob", scope: :resource) }
          it "should be equal" do
            expect(role1).to eq(role2)
          end
        end
        describe "two roles of the same type that have a different agent or scope" do
          let(:role2) { Good.build(person: "bob", scope: :policy) }
          let(:role3) { Good.build(person: "sue", scope: :resource) }
          it "should not be equal" do
            expect(role1).not_to eq(role2)
            expect(role1).not_to eq(role3)
          end
        end
        describe "two roles of different types" do
          let(:role2) { Better.build(person: "bob", scope: :resource) }
          it "should not be equal" do
            expect(role1).not_to eq(role2)
          end
        end
      end

      describe "instance methods" do
        let(:agent) { Ddr::Auth::Person.build("bob") }
        let(:scope) { Ddr::Vocab::Scopes.Resource }
        subject do
          Good.new.tap do |role|
            role.agent = agent
            role.scope = scope
          end
        end
        its(:scope_type) { is_expected.to eq(:resource) }
        its(:agent_name) { is_expected.to eq("bob") }
        its(:agent_type) { is_expected.to eq(:person) }
        its(:to_h) { is_expected.to eq({type: :good, person: "bob", scope: :resource}) }
        its(:to_hash) { is_expected.to eq({type: :good, person: "bob", scope: :resource}) }
        its(:permissions) { is_expected.to eq([:read]) }
      end

    end
  end
end
