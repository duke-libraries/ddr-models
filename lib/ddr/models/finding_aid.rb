module Ddr::Models
  class FindingAid

    attr_reader :ead_id

    def initialize(ead_id)
      @ead_id = ead_id
    end

    def url
      @url ||= doc.css("eadid").attr("url").text
    end

    def title
      @title ||= doc.css("titleproper").children.first.text.strip
    end

    private

    # @raise [OpenURI::HTTPError] if 404, etc.
    def doc
      @doc ||= Nokogiri::XML(open(ead_xml_url))
    end

    def ead_xml_url
      Ddr::Models.ead_xml_base_url + ead_id + ".xml"
    end

  end
end
