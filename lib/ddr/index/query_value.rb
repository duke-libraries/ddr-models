module Ddr::Index
  class QueryValue

    class << self
      def build(value)
        RSolr.solr_escape(value)
      end

      def or_values(*values)
        value = values.map { |v| build(v) }.join(" OR ")
        "(#{value})"
      end
    end

  end
end
