module Ddr
  module Models
    module HasChildren
      extend ActiveSupport::Concern

      def first_child
        if datastreams.include?(Ddr::Datastreams::CONTENT_METADATA) && datastreams[Ddr::Datastreams::CONTENT_METADATA].has_content?
          first_child_pid = datastreams[Ddr::Datastreams::CONTENT_METADATA].first_pid
        else
          first_child_pid = ActiveFedora::SolrService.query(association_query(:children), rows: 1, sort: "#{Ddr::IndexFields::IDENTIFIER} ASC").first["id"]
        end      
        begin
          ActiveFedora::Base.find(first_child_pid, :cast => true) if first_child_pid
        rescue ActiveFedora::ObjectNotFound
          nil
        end
      end

    end
  end
end