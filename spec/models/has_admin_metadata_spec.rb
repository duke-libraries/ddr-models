require 'spec_helper'
require 'support/ezid_mock_identifier'

module Ddr::Models
  RSpec.describe HasAdminMetadata, type: :model, contacts: true do

    describe "permanent id and permanent url" do
      subject { FactoryGirl.build(:item) }

      describe "#assign_permanent_id!" do
        it "should assign the permanent id later" do
          expect(subject.permanent_id_manager).to receive(:assign_later) { nil }
          subject.assign_permanent_id!
        end
        context "when the object is created (first saved)" do
          context "and auto-assignment is enabled" do
            before { allow(Ddr::Models).to receive(:auto_assign_permanent_ids) { true } }
            it "should assign a permanent id" do
              expect(subject).to receive(:assign_permanent_id!) { nil }
              subject.save!
            end
          end
          context "and auto-assignment is disabled" do
            before { allow(Ddr::Models).to receive(:auto_assign_permanent_ids) { false } }
            it "should not assign a permanent id" do
              expect(subject).not_to receive(:assign_permanent_id!)
              subject.save!
            end
          end
        end
        context "when saved" do
          context "and auto-assignment is enabled" do
            before { allow(Ddr::Models).to receive(:auto_assign_permanent_ids) { true } }
            it "should assign a permanent id once" do
              expect(subject).to receive(:assign_permanent_id!).once { nil }
              subject.save!
              subject.dc_title = ["New Title"]
              subject.save!
            end
          end
          context "and auto-assignment is disabled" do
            before { allow(Ddr::Models).to receive(:auto_assign_permanent_ids) { false } }
            it "should not assign a permanent id" do
              expect(subject).not_to receive(:assign_permanent_id!)
              subject.save!
            end
          end
        end
      end

      describe "lifecycle" do
        let!(:identifier) { Ezid::MockIdentifier.new(id: "ark:/99999/fk4zzz", status: "public") }
        before do
          allow(Ddr::Models).to receive(:auto_assign_permanent_ids) { false }
          allow(Ezid::Identifier).to receive(:find).with("ark:/99999/fk4zzz") { identifier }
          subject.permanent_id = "ark:/99999/fk4zzz"
          subject.save!
        end
        it "should update the status of the identifier when the object is destroyed" do
          expect { subject.destroy }.to change(identifier, :status).from("public").to("unavailable | deleted")
        end
      end

      describe "events" do
        before { allow(Ddr::Models).to receive(:auto_assign_permanent_ids) { true } }
        context "when the operation succeeds" do
          let!(:mock_identifier) { Ezid::MockIdentifier.new(id: "ark:/99999/fk4zzz",
                                                            metadata: "_target: http://example.com") }
          before do
            allow(Ezid::Identifier).to receive(:create) { mock_identifier }
            allow(Ezid::Identifier).to receive(:find) { mock_identifier }
            allow(subject.permanent_id_manager).to receive(:record) { mock_identifier }
          end
          it "should create a success event" do
            expect { subject.save }.to change { subject.update_events.count }.by(1)
          end
        end
        context "when there's an exception" do
          before { allow(Ezid::Identifier).to receive(:create).and_raise(Ezid::Error) }
          it "should create a failure event" do
            begin
              subject.save
            rescue Ezid::Error
            end
            expect(subject.update_events.last).to be_failure
          end
        end
      end
    end

    describe "workflow" do

      subject { FactoryGirl.build(:item) }

      describe "#published?" do
        context "object is published" do
          before { allow(subject).to receive(:workflow_state) { Ddr::Managers::WorkflowManager::PUBLISHED } }
          it "should return true" do
            expect(subject).to be_published
          end
        end
        context "object is not published" do
          before { allow(subject).to receive(:workflow_state) { nil } }
          it "should return false" do
            expect(subject).not_to be_published
          end
        end
      end

      describe "#publish" do
        it "should publish the object" do
          subject.publish
          expect(subject).to be_published
        end
      end

      describe "#publish!" do
        it "should publish and persist the object" do
          subject.publish!
          expect(subject.reload).to be_published
        end
      end

      describe "#unpublish" do
        before { subject.publish }
        it "should unpublish the object" do
          subject.unpublish
          expect(subject).not_to be_published
        end
      end

      describe "#unpublish!" do
        before { subject.publish! }
        it "should unpublish and persist the object" do
          subject.unpublish!
          expect(subject.reload).not_to be_published
        end
      end
    end

    describe "roles" do

      subject { FactoryGirl.build(:item) }

      describe "#copy_resource_roles_from" do
        let(:other) { FactoryGirl.build(:collection) }
        let(:resource_roles) do
          [ FactoryGirl.build(:role, :viewer, :public, :resource),
            FactoryGirl.build(:role, :editor, :group, :resource) ]
        end
        let(:policy_roles) do
          [ FactoryGirl.build(:role, :curator, :person, :policy) ]
        end
        before do
          other.roles.grant *resource_roles
          other.roles.grant *policy_roles
          subject.copy_resource_roles_from(other)
        end
        its(:roles) { should include(*resource_roles) }
        its(:roles) { should_not include(*policy_roles) }
      end

      describe "#grant_roles_to_creator" do
        let(:user) { FactoryGirl.build(:user) }
        before { subject.grant_roles_to_creator(user) }
        its(:roles) { should include(Ddr::Auth::Roles::Role.new(role_type: "Editor", agent: user.agent, scope: "resource")) }
      end

      describe "persistence" do
        let(:role) { FactoryGirl.build(:role, :downloader, :public) }
        it "should persist the role information" do
          subject.roles.grant role
          subject.save!
          subject.reload
          expect(subject.roles.role_set).to contain_exactly(role)
        end
      end

      describe "contacts" do
        before do
          allow(Ddr::Models::Contact).to receive(:get).with(:find, slug: 'xa') do
            {'id'=>1, 'slug'=>'xa', 'name'=>'Contact A', 'short_name'=>'A'}
          end
          allow(Ddr::Models::Contact).to receive(:get).with(:find, slug: 'yb') do
            {'id'=>1, 'slug'=>'yb', 'name'=>'Contact B', 'short_name'=>'B'}
          end
        end
        describe "#research_help" do
          before { subject.research_help_contact = 'yb' }
          it "should return the appropriate contact" do
            expect(subject.research_help.slug).to eq('yb')
          end
        end
      end

    end
  end
end
