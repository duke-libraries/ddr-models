module Ddr
  module Managers
    class WorkflowManager < Manager

      PUBLISHED = "published"
      UNPUBLISHED = "unpublished"

      def published?
        object.workflow_state == PUBLISHED
      end


      def publish!(include_descendants: true)
        unless published?
          publish
          object.save!
        end
        if include_descendants && object.respond_to?(:children)
          object.children.each { |child| child.publish!(include_descendants: include_descendants) }
        end
      end

      def unpublish!
        if published?
          unpublish
          object.save!
        end
        if object.respond_to?(:children)
          object.children.each { |child| child.unpublish! }
        end
      end

      private

      def publish
        object.workflow_state = PUBLISHED
      end

      def unpublish
        object.workflow_state = UNPUBLISHED
      end

    end
  end
end

