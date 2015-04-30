module Ddr
  module Events
    class ValidationEvent < Event

      include PreservationEventBehavior

      self.preservation_event_type = :val

    end
  end
end
