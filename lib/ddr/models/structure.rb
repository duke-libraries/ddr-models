module Ddr
  module Models
    #
    # Wraps a Nokogiri (XML) Document
    #
    class Structure < SimpleDelegator

      def initialize(xml_doc=nil)
        super
      end

      def struct_divs
        @struct_divs ||= build_struct_divs(structMaps)
      end

      def structMap(type='default')
        xpath("//xmlns:structMap[@TYPE='#{type}']").first
      end

      def as_xml_document
        __getobj__
      end

      private

      def structMaps
        xpath("//xmlns:structMap")
      end

      def build_struct_divs(structMaps)
        sdivs = {}
        structMaps.each do |structMap|
          type = structMap['TYPE'] || 'default'
          raise StandardError, "Multiple '#{type}' structMaps" if sdivs[type].present?
          sdivs[type] = Ddr::Models::StructDiv.new(structMap)
        end
        sdivs
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