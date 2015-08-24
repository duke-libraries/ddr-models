module Ddr::Index
  class Filter

    class << self
      def where(conditions)
        new.where(conditions)
      end

      def raw(*clauses)
        new.raw(*clauses)
      end
    end

    attr_accessor :clauses

    def initialize
      @clauses = [ ]
    end

    def where(conditions)
      clauses = conditions.map { |field, value| raw_query(field, value) }
      raw(*clauses)
    end

    def raw(*clauses)
      self.clauses += clauses
      self
    end

    private

    # Copied from ActiveFedora::SolrService
    def raw_query(key, value)
      "_query_:\"{!raw f=#{key}}#{value.gsub('"', '\"')}\""
    end

  end
end
