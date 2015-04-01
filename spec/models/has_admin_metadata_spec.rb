require 'spec_helper'

module Ddr
  module Models
    RSpec.describe HasAdminMetadata, type: :model do

      describe "permanent id and permanent url" do

        before(:all) do
          class PermanentlyIdentifiable < ActiveFedora::Base
            include Describable
            include Indexing
            include AccessControllable
            include HasAdminMetadata
            include EventLoggable
          end
        end

        after(:all) do
          Ddr::Models.send(:remove_const, :PermanentlyIdentifiable)
        end

        subject { PermanentlyIdentifiable.new }

        describe "permanent_id" do
          describe "when a permanent id has not been assigned" do
            it "should be nil" do
              expect(subject.permanent_id).to be_nil
            end
          end
        end

        describe "object lifecycle" do
          context "when created" do
            context "and auto-assignment is enabled" do
              before { allow(Ddr::Models).to receive(:auto_assign_permanent_ids) { true } }
              it "should assign a permanent id" do
                expect_any_instance_of(PermanentlyIdentifiable).to receive(:assign_permanent_id!) { nil }
                PermanentlyIdentifiable.create
              end
            end
            context "and auto-assignment is disabled" do
              before { allow(Ddr::Models).to receive(:auto_assign_permanent_ids) { false } }
              it "should not assign a permanent id" do
                expect_any_instance_of(PermanentlyIdentifiable).not_to receive(:assign_permanent_id!)
                PermanentlyIdentifiable.create
              end
            end
          end        
          context "when saved" do
            context "and auto-assignment is enabled" do
              before { allow(Ddr::Models).to receive(:auto_assign_permanent_ids) { true } }
              it "should assign a permanent id once" do
                expect(subject).to receive(:assign_permanent_id!).once { nil }
                subject.save
                subject.title = ["New Title"]
                subject.save
              end
            end
            context "and auto-assignment is disabled" do
              before { allow(Ddr::Models).to receive(:auto_assign_permanent_ids) { false } }
              it "should not assign a permanent id" do
                expect(subject).not_to receive(:assign_permanent_id!)
                subject.save
              end
            end
          end
        end

        describe "#assign_permanent_id!" do
          it "should assign the permanent id later" do
            expect(subject.permanent_id_manager).to receive(:assign_later) { nil }
            subject.assign_permanent_id!
          end
        end

        describe "events" do
          before { allow(Ddr::Models).to receive(:auto_assign_permanent_ids) { true } }  
          context "when the operation succeeds" do
            let(:stub_identifier) { double(id: "ark:/99999/fk4zzz", metadata: "_target: http://example.com") }
            before { allow_any_instance_of(Ddr::Managers::PermanentIdManager).to receive(:mint) { stub_identifier } }
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

        describe "indexing" do
          let(:permanent_id) { "ark:/99999/fk4zzz" }
          let(:permanent_url) { "http://id.library.duke.edu/ark:/99999/fk4zzz" }
          before do
            subject.permanent_id = permanent_id
            subject.permanent_url = permanent_url
          end
          it "should index the permanent id value" do
            expect(subject.to_solr[Ddr::IndexFields::PERMANENT_ID]).to eq(permanent_id)
          end
          it "should index the permanent url" do
            expect(subject.to_solr[Ddr::IndexFields::PERMANENT_URL]).to eq(permanent_url)
          end
        end

      end

      describe "workflow" do
        before(:all) do
          class Workflowable < ActiveFedora::Base
            include AccessControllable
            include HasAdminMetadata
          end
        end

        after(:all) do
          Ddr::Models.send(:remove_const, :Workflowable)
        end

        subject { Workflowable.new }

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
        let(:resource) { Item.new }

        describe "#role_based_permissions" do
          let(:policy) { Collection.new(pid: "coll:1") }
          let(:user) { FactoryGirl.build(:user) }
          before do
            resource.admin_policy = policy
            allow(user).to receive(:persisted?) { true }
            resource.roles.grant type: :downloader, group: Ddr::Auth::Groups::Public, scope: :resource
            policy.roles.grant type: :contributor, person: user, scope: :policy
          end
          it "should return the list of permissions granted to the user's agents on the resource in resource scope, plust the permissions granted to the user's agents on the resource policy in policy scope" do
            expect(resource.role_based_permissions(user)).to match_array([:read, :download, :add_children])
          end
        end

        describe "when permissions have changed" do
          it "should update the resource roles" do
            resource.permissions_attributes = [{access: "edit", type: "group", name: "Editors"},
                                               {access: "discover", type: "group", name: "public"},
                                               {access: "read", type: "person", name: "bob@example.com"}]
            resource.save!
            expect(resource.roles.granted).to include(Ddr::Auth::Roles::Viewer.build(person: "bob@example.com", scope: :resource),
                                                     Ddr::Auth::Roles::Editor.build(group: "Editors", scope: :resource),
                                                     Ddr::Auth::Roles::Viewer.build(group: "public", scope: :resource))
          end
        end

        describe "when permissions haven't changed" do
          it "shouldn't change the resource roles" do
            expect { resource.save }.not_to change { resource.roles.where(scope: :resource) }
          end
        end

      end
    
    end
  end
end
