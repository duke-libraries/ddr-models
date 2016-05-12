module Ddr
  module Models
    module HasStructMetadata
      extend ActiveSupport::Concern

      included do
        contains Ddr::Models::File::STRUCT_METADATA,
                 class_name: 'Ddr::Models::StructuralMetadataFile'
      end

      def structure
        unless @structure
          if attached_files[Ddr::Models::File::STRUCT_METADATA].content
            @structure = Ddr::Models::Structure.new(Nokogiri::XML(attached_files[Ddr::Models::File::STRUCT_METADATA].content))
          end
        end
        @structure
      end

      def build_default_structure
        structure = Ddr::Models::Structure.new(Ddr::Models::Structure.template)
        children = find_children
        children.each do |child|
          add_to_struct_map(structure, child)
        end
        structure
      end

      def multires_image_file_paths(type='default')
        ::SolrDocument.find(id).multires_image_file_paths(type)
      end

      private

      def find_children
        query = ActiveFedora::SolrQueryBuilder.construct_query_for_rel([[ self.class.reflect_on_association(:children), self.id ]])
        sort = "#{Ddr::Index::Fields::LOCAL_ID} ASC, #{Ddr::Index::Fields::OBJECT_CREATE_DATE} ASC"
        ActiveFedora::SolrService.query(query, sort: sort, rows: 999999)
      end

      def add_to_struct_map(stru, child)
        div = create_div(stru)
        create_fptr(stru, div, child['id'])
      end

      def create_div(stru)
        div_count = stru.structMap_node('default').xpath('xmlns:div').size
        div = Nokogiri::XML::Node.new('div', stru.as_xml_document)
        div['ORDER'] = div_count + 1
        stru.structMap_node('default').add_child(div)
        div
      end

      def create_fptr(stru, div, id)
        fptr = Nokogiri::XML::Node.new('fptr', stru.as_xml_document)
        fptr['CONTENTIDS'] = id
        div.add_child(fptr)
      end

    end
  end
end
