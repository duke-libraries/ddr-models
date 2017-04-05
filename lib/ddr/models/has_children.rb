module Ddr
  module Models
    module HasChildren

      DEFAULT_SORT = "#{Ddr::Index::Fields::LOCAL_ID} ASC, #{Ddr::Index::Fields::OBJECT_CREATE_DATE} ASC"

      def first_child
        ActiveFedora::SolrService.lazy_reify_solr_results(sorted_children).first
      end

      def default_structure
        if children.present?
          build_default_structure
        end
      end

      def sorted_children
        ActiveFedora::SolrService.query(association_query(:children), sort: DEFAULT_SORT, rows: 999999)
      end

      private

      def build_default_structure
        document = Ddr::Models::Structure.xml_template
        structure = Ddr::Models::Structure.new(document)
        metshdr = structure.add_metshdr
        structure.add_agent(parent: metshdr, role: Ddr::Models::Structures::Agent::ROLE_CREATOR,
                            name: Ddr::Models::Structures::Agent::NAME_REPOSITORY_DEFAULT)
        structmap = structure.add_structmap(type: Ddr::Models::Structure::TYPE_DEFAULT)
        add_children(structure, structmap, sorted_children)
        structure
      end

      def add_children(structure, structmap, children)
        count = 0
        children.each do |child|
          count += 1
          div = structure.add_div(parent: structmap, order: count)
          structure.add_mptr(parent: div, href: child[Ddr::Index::Fields::PERMANENT_ID])
        end
      end

    end
  end
end
