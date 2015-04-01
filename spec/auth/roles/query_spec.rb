module Ddr::Auth
  module Roles
    RSpec.describe Query do

      before do
        class ResourceWithRoles < ActiveTriples::Resource
          property :role, predicate: Ddr::Vocab::Roles.hasRole
        end
      end

      after do
        Roles.send(:remove_const, :ResourceWithRoles)
      end

      let(:role_set) { RoleSet.new(ResourceWithRoles.new.role) }

      subject { described_class.new(role_set) }

      describe "#where" do
        let(:curator) { FactoryGirl.build(:person) }
        let(:editor) { FactoryGirl.build(:person) }
        let(:other_person) { FactoryGirl.build(:group) }
        let(:other_group) { FactoryGirl.build(:group) }
        let(:contributor_group) { FactoryGirl.build(:group) }
        let(:downloader_group) { FactoryGirl.build(:group) }
        let(:viewer_group) { FactoryGirl.build(:group) }
        let(:contributor_role) { Contributor.build(group: contributor_group, scope: :resource) }
        let(:downloader_role) { Downloader.build(group: downloader_group, scope: :resource) }
        let(:editor_role) { Editor.build(person: editor, scope: :resource) }
        let(:curator_role) { Curator.build(person: curator, scope: :policy) }
        let(:viewer_role) { Viewer.build(group: viewer_group, scope: :policy) }
        let(:policy_roles) { [curator_role, viewer_role] }
        let(:resource_roles) { [contributor_role, downloader_role, editor_role] }
        before do
          role_set.grant(contributor_role, downloader_role, editor_role, curator_role, viewer_role)
        end
        describe "filtering by role type" do
          it "should filter by a type" do
            expect(subject.where(type: :contributor)).to eq([contributor_role])
          end
          it "should filter by a list of types" do
            expect(subject.where(type: [:contributor, :curator, :metadata_editor])).to contain_exactly(contributor_role, curator_role)
          end
        end
        describe "filtering by group" do
          it "should filter by a group" do
            expect(subject.where(group: contributor_group)).to eq([contributor_role])
          end
          it "should filter by a group name" do
            expect(subject.where(group: contributor_group.agent_name)).to eq([contributor_role])
          end
          it "should filter by a list of groups" do
            expect(subject.where(group: [contributor_group, other_group, downloader_group])).to contain_exactly(contributor_role, downloader_role)
          end
          it "should filter by a list of group names" do
            expect(subject.where(group: [contributor_group.agent_name, downloader_group.agent_name, other_group.agent_name])).to contain_exactly(contributor_role, downloader_role)
          end
        end
        describe "filtering be person" do
          it "should filter by a person" do
            expect(subject.where(person: curator)).to eq([curator_role])
          end
          it "should filter by person name" do
            expect(subject.where(person: curator.agent_name)).to eq([curator_role])
          end
          it "should filter by a list of persons" do
            expect(subject.where(person: [curator, other_person])).to eq([curator_role])
          end
          it "should filter by a list of person names" do
            expect(subject.where(person: [curator.agent_name, other_person.agent_name])).to eq([curator_role])
          end
        end
        describe "filtering by agent" do
          it "should filter by an agent" do
            expect(subject.where(agent: curator)).to eq([curator_role])
          end
          it "should filter by an agent name" do
            expect(subject.where(agent: curator.agent_name)).to eq([curator_role])
          end
          it "should filter by a list of agents" do
            expect(subject.where(agent: [curator, other_person, downloader_group])).to contain_exactly(curator_role, downloader_role)
          end
          it "should filter by a list of agent names" do
            expect(subject.where(agent: [curator.agent_name, other_person.agent_name, other_group.agent_name, contributor_group.agent_name])).to contain_exactly(contributor_role, curator_role)
          end

        end
        describe "filtering by scope" do
          it "should filter by the policy scope term" do
            expect(subject.where(scope: Ddr::Vocab::Scopes.Policy)).to eq(policy_roles)
          end
          it "should filter by the resource scope term" do
            expect(subject.where(scope: Ddr::Vocab::Scopes.Resource)).to eq(resource_roles)
          end
          it "should filter by the policy scope type" do
            expect(subject.where(scope: :policy)).to eq(policy_roles)
          end
          it "should filter by the resource scope type" do
            expect(subject.where(scope: :resource)).to eq(resource_roles)
          end
        end
      end

    end
  end
end
