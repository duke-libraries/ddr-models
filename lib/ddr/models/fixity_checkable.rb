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
 
    end
  end
end