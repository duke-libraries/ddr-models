require 'rsolr'

module RSolr
  class << self
    alias_method :escape, :solr_escape
  end
end
