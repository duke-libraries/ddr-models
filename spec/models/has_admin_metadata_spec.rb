require 'spec_helper'

module Ddr
  module Models
    RSpec.describe HasAdminMetadata, type: :model do

      describe "permanent id and permanent url" do

        before(:all) do
          class PermanentlyIdentifiable < ActiveFedora::Base
            include Ddr::Models::Describable
            include Ddr::Models::Indexing
            include Ddr::Models::HasWorkflow
            include Ddr::Models::HasAdminMetadata
            include Ddr::Models::EventLoggable
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

      describe "role assignments" do

        before(:all) do
          class RoleAssignable < ActiveFedora::Base
            include HasAdminMetadata
          end
        end
        
        after(:all) do
          Ddr::Models.send(:remove_const, :RoleAssignable)
        end

        subject { RoleAssignable.new }

        describe "#principal_has_role?" do
          it "should respond when given a list of principals and a valid role" do
            expect { subject.principal_has_role?(["bob", "admins"], :administrator) }.not_to raise_error
          end
          it "should respond when given a principal name and a valid role" do
            expect { subject.principal_has_role?("bob", :administrator) }.not_to raise_error
          end
          it "should raise an error when given an invalid role" do
            expect { subject.principal_has_role?("bob", :foo) }.to raise_error
          end
        end
      end
    
    end
  end
end
