module Ddr
  module Models
    module HasStructMetadata
      extend ActiveSupport::Concern

      included do
        has_file_datastream name: Ddr::Datastreams::STRUCT_METADATA,
                            type: Ddr::Datastreams::StructuralMetadataDatastream
      end

      def structure
        unless @structure
          if datastreams[Ddr::Datastreams::STRUCT_METADATA].content
            @structure = Ddr::Models::Structure.new(Nokogiri::XML(datastreams[Ddr::Datastreams::STRUCT_METADATA].content))
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
        ::SolrDocument.find(pid).multires_image_file_paths(type)
      end

      private

      def find_children
        query = association_query(:children)
        sort = "#{Ddr::IndexFields::LOCAL_ID} ASC, #{Ddr::IndexFields::OBJECT_CREATE_DATE} ASC"
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

      def create_fptr(stru, div, pid)
        fptr = Nokogiri::XML::Node.new('fptr', stru.as_xml_document)
        fptr['CONTENTIDS'] = "info:fedora/#{pid}"
        div.add_child(fptr)
      end

    end
  end
end
