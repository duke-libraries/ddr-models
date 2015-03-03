module Ddr
  module Events
    class DeletionEvent < Event 

      include PreservationEventBehavior

      self.description = "Object deleted"
      self.preservation_event_type = :del

    end
  end
end
