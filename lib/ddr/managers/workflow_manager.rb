module Ddr
  module Managers
    class WorkflowManager < Manager

      PUBLISHED = "published"
      UNPUBLISHED = "unpublished"

      def published?
        object.workflow_state == PUBLISHED
      end
      
      def publish
        object.workflow_state = PUBLISHED
      end

      def publish!
        publish
        object.save
      end
      
      def unpublish
        object.workflow_state = UNPUBLISHED
      end

      def unpublish!
        unpublish
        object.save
      end

    end
  end
end
      
