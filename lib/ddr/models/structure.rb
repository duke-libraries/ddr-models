module Ddr
  module Models
    #
    # Wraps a Nokogiri (XML) Document
    #
    class Structure < SimpleDelegator

      def initialize(xml_doc=nil)
        super
      end

      def struct_maps
        @struct_maps ||= build_struct_maps(structMap_nodes)
      end

      def structMap_node(type='default')
        xpath("//xmlns:structMap[@TYPE='#{type}']").first
      end

      def as_xml_document
        __getobj__
      end

      private

      def structMap_nodes
        xpath("//xmlns:structMap")
      end

      def build_struct_maps(structMap_nodes)
        smaps = {}
        structMap_nodes.each do |structMap_node|
          type = structMap_node['TYPE'] || 'default'
          raise StandardError, "Multiple '#{type}' structMaps" if smaps[type].present?
          smaps[type] = Ddr::Models::StructDiv.new(structMap_node)
        end
        smaps
      end

      def self.template
        Nokogiri::XML(
            '<mets xmlns="http://www.loc.gov/METS/" xmlns:xlink="http://www.w3.org/1999/xlink">
              <structMap TYPE="default" />
            </mets>'
            ) do |config|
                config.noblanks
              end
      end

    end
  end
end