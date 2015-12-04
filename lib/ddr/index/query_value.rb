module Ddr::Index
  class QueryValue

    class << self
      def build(value)
        RSolr.solr_escape(value)
      end

      # @param values [Enumerable<String>]
      def or_values(values)
        unless values.is_a?(::Enumerable) && values.present?
          raise ArgumentError, "`#{self.name}.or_values` requires a non-empty enumerable of strings."
        end
        "(%s)" % values.map { |value| build(value) }.join(" OR ")
      end
    end

  end
end
