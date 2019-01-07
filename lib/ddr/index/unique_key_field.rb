require 'singleton'

module Ddr::Index
  class UniqueKeyField < Field
    include Singleton

    def initialize
      super Solrizer.default_field_mapper.id_field
    end

  end
end
