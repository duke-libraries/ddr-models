module Ddr
  module Models
    module HasChildren

      def first_child
        if datastreams.include?(Ddr::Datastreams::CONTENT_METADATA) && datastreams[Ddr::Datastreams::CONTENT_METADATA].has_content?
          # DEPRECATED
          first_child_pid = datastreams[Ddr::Datastreams::CONTENT_METADATA].first_pid
          first_child_pid ? ActiveFedora::Base.find(first_child_pid) : nil
        else
          ActiveFedora::Base.where(association_query(:children)).order("#{Ddr::IndexFields::IDENTIFIER} ASC").first
        end      
      end

    end
  end
end
