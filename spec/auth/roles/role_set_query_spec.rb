module Ddr::Auth
  module Roles
    RSpec.describe RoleSetQuery do

      shared_examples "a role set query" do

        subject { described_class.new(role_set) }

        let(:curator) { "curator@example.com" }
        let(:editor) { "editor@example.com" }
        let(:other_person) { "other@example.com" }
        let(:other_group) { "Others" }
        let(:contributor_group) { "Contributors" }
        let(:downloader_group) { "Downloaders" }
        let(:viewer_group) { "Viewers" }
        let(:contributor_role) { Role.build(type: "Contributor", agent: contributor_group, scope: "resource") }
        let(:downloader_role) { Role.build(type: "Downloader", agent: downloader_group, scope: "resource") }
        let(:editor_role) { Role.build(type: "Editor", agent: editor, scope: "resource") }
        let(:curator_role) { Role.build(type: "Curator", agent: curator, scope: "policy") }
        let(:viewer_role) { Role.build(type: "Viewer", agent: viewer_group, scope: "policy") }
        let(:policy_roles) { [curator_role, viewer_role] }
        let(:resource_roles) { [contributor_role, downloader_role, editor_role] }

        before do
          role_set.grant(contributor_role, downloader_role, editor_role, curator_role, viewer_role)
        end

        describe "filtering by role type" do
          it "should filter by a type" do
            expect(subject.where(role_type: "Contributor").to_a).to eq([contributor_role])
            expect(subject.role_type("Contributor").to_a).to eq([contributor_role])
            expect(subject.type("Contributor").to_a).to eq([contributor_role])
          end
          it "should filter by a list of types" do
            expect(subject.where(role_type: ["Contributor", "Curator", "MetadataEditor"]).to_a)
              .to eq([contributor_role, curator_role])
            expect(subject.role_type(["Contributor", "Curator", "MetadataEditor"]).to_a)
              .to eq([contributor_role, curator_role])
            expect(subject.type(["Contributor", "Curator", "MetadataEditor"]).to_a)
              .to eq([contributor_role, curator_role])
          end
        end

        describe "filtering by agent" do
          it "should filter by an agent" do
            expect(subject.where(agent: curator).to_a).to eq([curator_role])
            expect(subject.agent(curator).to_a).to eq([curator_role])
          end
          it "should filter by a list of agents" do
            expect(subject.where(agent: [curator, other_person, downloader_group]).to_a)
              .to eq([downloader_role, curator_role])
            expect(subject.agent([curator, other_person, downloader_group]).to_a)
              .to eq([downloader_role, curator_role])
          end
        end

        describe "filtering by scope" do
          it "should filter by the policy scope" do
            expect(subject.where(scope: "policy").to_a).to eq(policy_roles)
            expect(subject.scope("policy").to_a).to eq(policy_roles)
          end
          it "should filter by the resource scope" do
            expect(subject.where(scope: "resource").to_a).to eq(resource_roles)
            expect(subject.scope("resource").to_a).to eq(resource_roles)
          end
        end

      end

      describe "with a PropertyRoleSet" do
        let(:role_assignable) do
          Class.new(ActiveTriples::Resource) do
            property :role, predicate: Ddr::Vocab::Roles.hasRole
          end
        end
        let(:role_set) { PropertyRoleSet.new(role_assignable.new.role) }
        it_behaves_like "a role set query"
      end

      describe "with a DetachedRoleSet" do
        let(:role_set) { DetachedRoleSet.new }
        it_behaves_like "a role set query"
      end

    end
  end
end
