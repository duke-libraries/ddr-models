module Ddr::Events
  class IngestionEvent < Event

    include PreservationEventBehavior

    self.preservation_event_type = :ing
    self.description = "Object ingested into the repository"

    def self.call(*args)
      super.tap do |event|
        if event.user_key.blank? && event.for_object.ingested_by
          event.user_key = event.for_object.ingested_by
          event.save
        end
      end
    end

  end
end
