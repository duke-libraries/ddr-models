module Ddr::Auth
  module Roles
    RSpec.describe RoleSetManager do

      subject { described_class.new(object) }

      let(:object) { Item.new }

      let(:role1) { FactoryGirl.build(:role, :editor, :person, :resource) }
      let(:role2) { FactoryGirl.build(:role, :curator, :group, :policy) }
      let(:role3) { FactoryGirl.build(:role, :viewer, :public) }

      describe "#grant" do
        describe "by attributes" do
          it "can grant a role" do
            subject.grant role1.to_h
            expect(object.roles.granted?(role1)).to be true
          end
          it "can grant multiple roles" do
            subject.grant role1.to_h, role2.to_h
            expect(object.roles.granted?(role1)).to be true
            expect(object.roles.granted?(role2)).to be true
          end
        end
        describe "by resource" do
          it "can grant a role by role instance" do
            subject.grant role1
            expect(object.roles.granted?(role1)).to be true
          end
          it "can grant multiple roles" do
            subject.grant role1, role2
            expect(object.roles.granted?(role1)).to be true
            expect(object.roles.granted?(role2)).to be true
          end
        end
      end

      describe "#revoke" do
        before { subject.grant role1, role2 }
        it "can revoke a role by type, agent name and (optionally) scope" do
          subject.revoke role1.to_h
          expect(object.roles.granted?(role1)).to be false
        end
        it "can revoke a role by role instance" do
          subject.revoke role1
          expect(object.roles.granted?(role1)).to be false
        end
        it "can revoke multiple roles" do
          subject.revoke role1, role2
          expect(object.roles.granted?(role1)).to be false
          expect(object.roles.granted?(role2)).to be false
        end
      end

      describe "#revoke_all" do
        before { subject.grant role1, role2 }
        it "revokes all roles" do
          subject.revoke_all
          expect(object.roles).to be_empty
        end
      end

      describe "#replace" do
        before { subject.grant role1, role2 }
        it "replaces the current role(s) with the new role(s)" do
          expect { subject.replace(role3) }.to change(subject, :to_a).from([role1, role2]).to([role3])
        end
      end

      describe "#granted?" do
        before { subject.grant role1 }
        it "returns true if an equivalent role has been granted" do
          expect(subject.granted?(role1.dup)).to be true
        end
        it "returns false if no equivalent role has been granted" do
          expect(subject.granted?(role2)).to be false
        end
        it "returns true if a role matching the arguments has been granted" do
          expect(subject.granted?(role1.to_h)).to be true
          expect(subject.granted?(role2.to_h)).to be false
        end
        it "coerces argument to Role" do
          expect(subject.granted?(role_type: Roles::EDITOR, agent: role1.agent, scope: "resource"))
            .to be true
        end
      end

    end
  end
end
