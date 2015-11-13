require "resque"

module Ddr::Jobs
  module Job

    def self.extended(base)
      base.extend ClassMethods
    end

    module ClassMethods
      # @return [Array<String>] list of object ids queued for this job type.
      # @note Assumes that the object_id is the first argument of the .perform method.
      def queued_object_ids(**args)
        args[:type] = self
        __queue__.jobs(**args).map { |job| job["args"].first }
      end

      private

      def __queue__
        Queue.new(Resque.queue_from_class(self))
      end
    end

  end
end
