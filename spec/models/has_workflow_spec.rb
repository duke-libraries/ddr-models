require 'spec_helper'

module Ddr
  module Models
    RSpec.describe HasWorkflow, type: :model do

      before(:all) do
        class Workflowable < ActiveFedora::Base
          include HasWorkflow
        end
      end

      subject { Workflowable.new(pid: 'test:1') }

      describe "#published?" do
        context "object is published" do
          before { Ddr::Workflow::WorkflowState.create(pid: subject.pid, workflow_state: Ddr::Workflow::WorkflowState::PUBLISHED) }
          it "should return true" do
            expect(subject.published?).to eql(true)
          end
        end
        context "object is not published" do
          context "has never been published" do
            it "should return false" do
              expect(subject.published?).to eql(false)
            end
          end
          context "has been published and unpublished" do
            before { Ddr::Workflow::WorkflowState.create(pid: subject.pid, workflow_state: nil) }
            it "should return false" do
              expect(subject.published?).to eql(false)
            end
          end
        end
      end

      describe "#publish!" do
        it "should publish the object" do
          subject.publish!
          expect(subject.published?).to eql(true)
        end
      end

      describe "#unpublish!" do
        before { subject.publish! }
        it "should unpublish the object" do
          subject.unpublish!
          expect(subject.published?).to eql(false)
        end
      end

    end
  end
end