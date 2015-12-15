module Ddr::Index
  class QueryValue

    class << self
      # Returns an escaped query value
      # @param value [String] the unescaped value
      # @return [String] the escaped value
      def build(value)
        RSolr.solr_escape(value)
      end

      # Builds an escaped query value for use in filtering on a field for any value in the list of values
      # @param values [Enumerable<String>]
      # @return [String] query value
      def or_values(values)
        unless values.is_a?(::Enumerable) && values.present?
          raise ArgumentError, "`#{self.name}.or_values` requires a non-empty enumerable of strings."
        end
        "(%s)" % values.map { |value| build(value) }.join(" OR ")
      end
    end

  end
end
