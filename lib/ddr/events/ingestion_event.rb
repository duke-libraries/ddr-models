module Ddr::Events
  class IngestionEvent < Event

    include PreservationEventBehavior

    self.preservation_event_type = :ing
    self.description = "Object ingested into the repository"

  end
end
