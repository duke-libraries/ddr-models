require 'singleton'

module Ddr::Index
  class UniqueKeyField < Field
    include Singleton

    def initialize
      super SOLR_DOCUMENT_ID
    end

  end
end
