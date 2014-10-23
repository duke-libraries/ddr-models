module Ddr
  module Models
    module EventLoggable
      extend ActiveSupport::Concern

      def events
        event_class.for_object(self)
      end

      def update_events
        event_class(:update).for_object(self)
      end

      # TESTME
      def notify_event(type, args={})
        Ddr::Notifications.notify_event(type, args.merge(pid: pid))
      end

      def has_events?
        events.count > 0
      end

      private 

      def event_class_name(token=nil)
        type = token ? "#{token.to_s.camelize}Event" : "Event"
        "Ddr::Events::#{type}"
      end

      def event_class(token=nil)
        event_class_name(token).constantize
      end

    end
  end
end
