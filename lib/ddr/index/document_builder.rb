module Ddr::Index
  class DocumentBuilder

    def self.build(doc)
      SolrDocument.new(doc)
    end

  end
end
