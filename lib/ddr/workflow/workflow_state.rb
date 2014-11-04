module Ddr
  module Workflow
    class WorkflowState < ActiveRecord::Base

      PUBLISHED = "published"
      
      def self.workflow_state_for_object(obj)
        workflow_state_for_pid(obj.pid)
      end

      def self.workflow_state_for_pid(pid)
        for_pid(pid).present? ? for_pid(pid).first.workflow_state : nil
      end

      def self.set_for_object(obj, state)
        set_for_pid(obj.pid, state)
      end

      def self.set_for_pid(pid, state)
        if for_pid(pid).present?
          for_pid(pid).first.update(workflow_state: state)
        else
          create(pid: pid, workflow_state: state)
        end
      end

      private

      def self.for_object(obj)
        for_pid(obj.pid)
      end

      def self.for_pid(pid)
        where(pid: pid)
      end
      
    end
  end
end