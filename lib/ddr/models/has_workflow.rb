module Ddr
  module Models
    module HasWorkflow
      extend ActiveSupport::Concern

      PUBLISHED = Ddr::Workflow::WorkflowState::PUBLISHED
      UNPUBLISHED = nil

      def workflow_state
        Ddr::Workflow::WorkflowState.workflow_state_for_object(self)
      end

      def published?
        self.workflow_state == PUBLISHED
      end
      
      def publish!
        Ddr::Workflow::WorkflowState.set_for_object(self, PUBLISHED)
        update_index
      end
      
      def unpublish!
        Ddr::Workflow::WorkflowState.set_for_object(self, UNPUBLISHED)
        update_index
      end

    end
  end
end