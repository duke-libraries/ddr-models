module Ddr::Index
  class QueryClause

    PRESENT = "[* TO *]"
    TERM = "{!term f=%s}%s"
    BEFORE_DAYS = "[* TO NOW-%sDAYS]"

    class << self
      # Builds a standard query clause, no escaping applied.
      # @param field [Field, String] field
      # @param value [String] query value
      # @return [String] query clause
      def build(field, value)
        [field, value].join(":")
      end

      # Builds a query clause to retrieve the index document by unique key.
      def unique_key(value)
        term(UniqueKeyField.instance, value)
      end
      alias_method :id, :unique_key

      # Builds a query clause to filter where field does not have the given value.
      # @param field [Field, String] field
      # @param value [String] query value
      # @return [String] query clause
      def negative(field, value)
        build("-#{field}", value)
      end

      # Builds a query clause to filter where field is present (i.e, has any value)
      # @param field [Field, String] field
      # @return [String] query clause
      def present(field)
        build(field, PRESENT)
      end

      # Builds a query clause to filter where field is NOT present (no values)
      # @param field [Field, String] field
      # @return [String] query clause
      def absent(field)
        negative(field, PRESENT)
      end

      # Builds a query clause to filter where field contains at least one of a set of values.
      # @param field [Field, String] field
      # @param values [Array<String>] query values
      # @return [String] query clause
      def or_values(field, values)
        build(field, QueryValue.or_values(values))
      end

      # Builds a query clause to filter where date field value is earlier than a date/time value.
      # @param field [Field, String] field
      # @param value [Object] query value, must be coercible to a Solr date string.
      # @return [String] query clause
      def before(field, date_time)
        value = "[* TO %s]" % Ddr::Utils.solr_date(date_time)
        build(field, value)
      end

      # Builds a query clause to filter where date field value is earlier than a number of days before now.
      # @param field [Field, String] field
      # @param value [String, Fixnum] query value, must be coercible to integer.
      # @return [String] query clause
      def before_days(field, days)
        value = BEFORE_DAYS % days.to_i
        build(field, value)
      end

      # Builds a "term query" clause to filter where field contains value.
      #   Double quotes are escaped.
      # @param field [Field, String] field
      # @param value [String] query value
      # @return [String] Solr term query
      def term(field, value)
        TERM % [field, value.gsub(/"/, '\"')]
      end
    end

  end
end
