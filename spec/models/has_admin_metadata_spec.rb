require 'spec_helper'
require 'support/ezid_mock_identifier'

module Ddr
  module Models
    RSpec.describe HasAdminMetadata, type: :model do

      describe "local id" do
        subject { FactoryGirl.build(:item) }
        describe "setting" do
          it "should set the value" do
            expect { subject.local_id = "foo" }.to change(subject, :local_id).from(nil).to("foo")
          end
        end        
        describe "re-setting" do
          before { subject.local_id = "foo" }
          it "should change the value" do
            expect { subject.local_id = "bar" }.to change(subject, :local_id).from("foo").to("bar")
          end
        end
        describe "indexing" do
          before { subject.local_id = "foo" }
          it "should index the local id value" do
            expect(subject.to_solr).to include(Ddr::IndexFields::LOCAL_ID => "foo")
          end
        end
        describe "finding" do
          before do
            subject.local_id = "foo"
            subject.save!
          end
          it "should be able to find by the local id" do
            expect(ActiveFedora::Base.where(Ddr::IndexFields::LOCAL_ID => "foo").first).to eq(subject)
          end
        end
      end

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
                subject.title = ["New Title"]
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

        describe "persistence" do
          before do
            subject.roles.grant type: "Downloader", agent: Ddr::Auth::Groups::PUBLIC
            subject.save!
            subject.reload
          end
          it "should persist the role information" do
            expect(subject.roles.granted).to eq([Ddr::Auth::Roles::Role.build(type: "Downloader", agent: Ddr::Auth::Groups::PUBLIC)])
          end
        end

        describe "#role_based_permissions" do
          let(:policy) { Collection.new(pid: "coll:1") }
          let(:user) { FactoryGirl.build(:user) }
          before do
            subject.admin_policy = policy
            allow(user).to receive(:persisted?) { true }
            subject.roles.grant type: "Downloader", agent: Ddr::Auth::Groups::PUBLIC, scope: "resource"
            policy.roles.grant type: "Contributor", agent: user.agent, scope: "policy"
          end
          it "should return the list of permissions granted to the user's agents on the subject in resource scope, plust the permissions granted to the user's agents on the subject's policy in policy scope" do
            expect(subject.role_based_permissions(user)).to match_array([:read, :download, :add_children])
          end
        end

      end    
    end
  end
end
