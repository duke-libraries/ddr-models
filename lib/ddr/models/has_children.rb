module Ddr
  module Models
    module HasChildren

      DEFAULT_SORT = "#{Ddr::Index::Fields::LOCAL_ID} ASC, #{Ddr::Index::Fields::OBJECT_CREATE_DATE} ASC"

      def first_child
        ActiveFedora::SolrService.lazy_reify_solr_results(sorted_children).first
      end

      def sorted_children
        ActiveFedora::SolrService.query(association_query(:children), sort: DEFAULT_SORT, rows: 999999)
      end

    end
  end
end
