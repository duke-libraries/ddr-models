module Ddr::Events
  class ReplicationEvent < Event
    include PreservationEventBehavior

    self.preservation_event_type = :rep
    self.description = "Object replicated"
  end
end
