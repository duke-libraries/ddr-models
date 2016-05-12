module Ddr
  module Events
    class FixityCheckEvent < Event

      include PreservationEventBehavior
      include ReindexObjectAfterSave

      self.preservation_event_type = :fix
      self.description = "Fixity check of attached files".freeze

      # Message sent by ActiveSupport::Notifications
      def self.call(*args)
        super do |payload|
          results = payload.delete(:results)
          payload[:outcome] = results.success? ? SUCCESS : FAILURE
          payload[:detail] = "Fixity check results:\n\n#{results}"
        end
      end

      def to_solr
        { Ddr::Index::Fields::LAST_FIXITY_CHECK_ON => event_date_time_s,
          Ddr::Index::Fields::LAST_FIXITY_CHECK_OUTCOME => outcome }
      end

    end
  end
end
