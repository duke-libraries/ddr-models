module Ddr
  module Events
    class VirusCheckEvent < Event

      include PreservationEventBehavior
      include ReindexObjectAfterSave

      self.preservation_event_type = :vir
      self.description = "Content file scanned for viruses"

      def to_solr
        { Ddr::IndexFields::LAST_VIRUS_CHECK_ON => event_date_time_s,
          Ddr::IndexFields::LAST_VIRUS_CHECK_OUTCOME => outcome }
      end

    end
  end
end
