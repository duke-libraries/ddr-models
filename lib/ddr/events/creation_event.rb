module Ddr
  module Events
    class CreationEvent < Event

      include PreservationEventBehavior

      self.preservation_event_type = :cre
      self.description = "Object created in the repository"

    end
  end
end