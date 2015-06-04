module Ddr
  module Models
    module FixityCheckable

      def datastreams_to_validate
        datastreams.select { |dsid, ds| ds.has_content? }
      end

      def fixity_checks
        Ddr::Events::FixityCheckEvent.for_object(self)
      end

      # Returns a Ddr::Actions::FixityCheck::Result for the object
      def fixity_check
        Ddr::Actions::FixityCheck.execute(self)
      end

      def last_fixity_check
        fixity_checks.last
      end

      def last_fixity_check_on
        last_fixity_check && last_fixity_check.event_date_time
      end

      def last_fixity_check_outcome
        last_fixity_check && last_fixity_check.outcome
      end

    end
  end
end
