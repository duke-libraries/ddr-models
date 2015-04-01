module Ddr::Auth
  module Roles
    RSpec.describe RoleSet, roles: true do

      before do
        class ResourceWithRoles < ActiveTriples::Resource
          property :role, predicate: Ddr::Vocab::Roles.hasRole
        end
      end

      after do
        Roles.send(:remove_const, :ResourceWithRoles)
      end

      subject { described_class.new(ResourceWithRoles.new.role) }

      let(:person) { FactoryGirl.build(:person) }

      describe "#grant" do
        let(:role1) { Ddr::Auth::Roles.build_role(type: :editor, person: "bob@example.com", scope: :resource) }
        let(:role2) { Ddr::Auth::Roles.build_role(type: :curator, person: "sue@example.com", scope: :policy) }
        describe "by attributes" do        
          it "should be able to grant a role by type, agent name and (optionally) scope" do
            subject.grant type: :editor, person: "bob@example.com", scope: :resource
            expect(subject.first).to eq(role1)
          end
          it "should not grant duplicate roles" do
            subject.grant type: :editor, person: "bob@example.com", scope: :resource
            subject.grant type: :editor, person: "bob@example.com", scope: :resource
            expect(subject.size).to eq(1)
            expect(subject.first).to eq(role1)
          end
          it "should be able to grant multiple roles" do
            roles = [{type: :editor, person: "bob@example.com", scope: :resource},
                     {type: :curator, person: "sue@example.com", scope: :policy}]
            subject.grant *roles
            expect(subject.size).to eq(2)
            expect(subject).to include(role1)
            expect(subject).to include(role2)
          end
        end
        describe "by resource" do
          it "should be able to grant a role by role instance" do
            subject.grant role1
            expect(subject).to include(role1)
          end
          it "should not grant duplicate roles" do
            subject.grant role1
            subject.grant role1
            expect(subject.size).to eq(1)
            expect(subject.first).to eq(role1)
          end
          it "should be able to grant multiple roles" do
            subject.grant role1, role2
            expect(subject.size).to eq(2)
            expect(subject).to include(Ddr::Auth::Roles.build_role(type: :editor, person: "bob@example.com", scope: :resource))
            expect(subject).to include(Ddr::Auth::Roles.build_role(type: :curator, person: "sue@example.com", scope: :policy))
          end
        end
      end

      describe "#granted?" do
        before do
          subject.grant type: :editor, person: "bob@example.com", scope: :resource
        end
        it "should return true if an equivalent role has been granted" do
          equiv_role = Ddr::Auth::Roles.build_role(type: :editor, person: "bob@example.com", scope: :resource)
          expect(subject.granted?(equiv_role)).to be true
          diff_role = Ddr::Auth::Roles.build_role(type: :editor, person: "bob@example.com", scope: :policy)
          expect(subject.granted?(diff_role)).to be false
        end
        it "should return true if a role matching the arguments has been granted" do
          expect(subject.granted?(type: :editor, person: "bob@example.com", scope: :resource)).to be true
          expect(subject.granted?(type: :curator, person: "bob@example.com", scope: :resource)).to be false
          expect(subject.granted?(type: :editor, person: "bob@example.com", scope: :policy)).to be false
        end
      end

      describe "#revoke" do
        let(:role1) { Ddr::Auth::Roles.build_role(type: :editor, person: "bob@example.com", scope: :resource) }
        let(:role2) { Ddr::Auth::Roles.build_role(type: :curator, person: "sue@example.com", scope: :policy) }
        before do
          subject.grant role1, role2
        end
        it "should be able to revoke a role by type, agent name and (optionally) scope" do
          subject.revoke type: :editor, person: "bob@example.com", scope: :resource
          expect(subject).not_to include(role1)
          expect(subject).to include(role2)
        end
        it "should be able to revoke a role by role instance" do
          subject.revoke Ddr::Auth::Roles.build_role(type: :editor, person: "bob@example.com", scope: :resource)
          expect(subject).not_to include(role1)
          expect(subject).to include(role2)
        end
        it "should be able to revoke multiple roles" do
          roles = [{type: :editor, person: "bob@example.com", scope: :resource},
                   {type: :curator, person: "sue@example.com", scope: :policy}]
          subject.revoke *roles
          expect(subject).not_to include(role1)
          expect(subject).not_to include(role2)
        end
      end

      describe "#revoke_all" do
        let(:role1) { Ddr::Auth::Roles.build_role(type: :editor, person: "bob@example.com", scope: :resource) }
        let(:role2) { Ddr::Auth::Roles.build_role(type: :curator, person: "sue@example.com", scope: :policy) }
        before do
          subject.grant role1, role2
        end
        it "should revoke all roles" do
          expect { subject.revoke_all }.to change(subject, :size).from(2).to(0)
        end        
      end

      describe "#to_a" do
        let(:role1) { Ddr::Auth::Roles.build_role(type: :editor, person: "bob@example.com", scope: :resource) }
        let(:role2) { Ddr::Auth::Roles.build_role(type: :curator, person: "sue@example.com", scope: :policy) }        
        before do
          subject.grant role1, role2
        end
        it "should return a plain array containing the roles" do
          result = subject.to_a
          expect(result).not_to be_a(described_class)
          expect(result).to be_a(Array)
          expect(result).to eq([role1, role2])
        end
      end

      describe "#where" do
        it "should be a Query object" do
          expect(subject.where(type: :contributor)).to be_a(Query)
        end
      end

    end    
  end
end
