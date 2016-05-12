module Ddr::Events
  class MigrationEvent < Event
    include PreservationEventBehavior

    self.description = "Object migrated"
    self.preservation_event_type = :mig

  end
end
