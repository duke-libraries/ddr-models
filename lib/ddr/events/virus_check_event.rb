module Ddr
  module Events
    class VirusCheckEvent < Event

      include PreservationEventBehavior
      include ReindexObjectAfterSave

      self.preservation_event_type = :vir
      self.description = "Content file scanned for viruses"

      # Message sent by ActiveSupport::Notifications
      def self.call(*args)
        notification = ActiveSupport::Notifications::Event.new(*args)
        result = notification.payload[:result] # Ddr::Antivirus::ScanResult instance
        create(pid: notification.payload[:pid],
               event_date_time: result.scanned_at,
               outcome: result.ok? ? SUCCESS : FAILURE,
               software: result.version,
               detail: result.to_s
               )    
      end

    end
  end
end
