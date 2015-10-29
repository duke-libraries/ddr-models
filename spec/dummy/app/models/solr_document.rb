require 'blacklight'

class SolrDocument
  include Blacklight::Solr::Document
  include Ddr::Models::SolrDocument
end
