require "nokogiri"

module Ddr::Models
  class FindingAid

    attr_reader :ead_id

    EAD_XMLNS = "urn:isbn:1-931666-22-9"

    def initialize(ead_id)
      @ead_id = ead_id
    end

    def url
      doc.css("eadid").attr("url").text
    end

    # The finding aid title
    def title
      doc.css("titleproper").children.first.text.strip
    end

    def repository
      collection.xpath('ead:did/ead:repository/ead:corpname', ead: EAD_XMLNS).text
    end

    def collection_date_span
      collection.xpath('ead:did/ead:unitdate[@type="inclusive"]', ead: EAD_XMLNS).text
    end

    def collection_number
      collection.xpath('ead:did/ead:unitid', ead: EAD_XMLNS).text
    end

    def collection_title
      collection.xpath('ead:did/ead:unittitle', ead: EAD_XMLNS).text
    end

    def extent
      collection.xpath('ead:did/ead:physdesc/ead:extent', ead: EAD_XMLNS).map(&:text).join("; ")
    end

    def abstract
      collection.xpath('ead:did/ead:abstract', ead: EAD_XMLNS).text
    end

    private

    def collection
      doc.xpath('//ead:archdesc[@level="collection"]', ead: EAD_XMLNS)
    end

    # @raise [OpenURI::HTTPError] if 404, etc.
    def doc
      @doc ||= Nokogiri::XML(open(ead_xml_url))
    end

    def ead_xml_url
      Ddr::Models.ead_xml_base_url + ead_id + ".xml"
    end

  end
end
