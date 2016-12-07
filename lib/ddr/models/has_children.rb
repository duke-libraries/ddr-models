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
        filesec = structure.add_filesec
        structmap = structure.add_structmap(type: Ddr::Models::Structure::TYPE_DEFAULT)
        filegrp = structure.add_filegrp(parent: filesec)
        add_children(structure, filegrp, structmap, sorted_children)
        structure
      end

      def add_children(structure, filegrp, structmap, children)
        count = 0
        children.each do |child|
          count += 1
          file = structure.add_file(parent: filegrp)
          structure.add_flocat(parent: file, href: child[Ddr::Index::Fields::PERMANENT_ID])
          div = structure.add_div(parent: structmap, order: count)
          structure.add_fptr(parent: div, fileid: file['ID'])
        end
      end

    end
  end
end
