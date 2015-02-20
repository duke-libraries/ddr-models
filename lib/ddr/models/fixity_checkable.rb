module Ddr
  module Models
    module FixityCheckable
      extend ActiveSupport::Concern

      included do
        index :last_fixity_check_on, :stored_sortable, type: :date
        index :last_fixity_check_outcome, :symbol
      end
   
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

      def last_fixity_check_on
        fixity_checks.last.event_date_time_s rescue nil
      end

      def last_fixity_check_outcome
        fixity_checks.last.outcome rescue nil
      end
 
    end
  end
end
