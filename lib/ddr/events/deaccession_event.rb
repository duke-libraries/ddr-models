module Ddr::Events
  class DeaccessionEvent < Event
    include PreservationEventBehavior

    self.description = "Object deaccessioned"
    self.preservation_event_type = :dea
  end
end
