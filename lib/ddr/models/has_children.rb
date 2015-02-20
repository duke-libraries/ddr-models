module Ddr
  module Models
    module HasChildren
      extend ActiveSupport::Concern

      def first_child
        first_child_pid = ActiveFedora::SolrService.query(association_query(:children), rows: 1, sort: "#{Ddr::IndexFields::IDENTIFIER} ASC").first["id"]
        begin
          ActiveFedora::Base.find(first_child_pid, :cast => true) if first_child_pid
        rescue ActiveFedora::ObjectNotFound
          nil
        end
      end

    end
  end
end