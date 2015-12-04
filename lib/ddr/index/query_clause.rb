module Ddr::Index
  class QueryClause

    PRESENT = "[* TO *]"
    TERM = "{!term f=%s}%s"
    BEFORE_DAYS = "[* TO NOW-%sDAYS]"

    class << self
      # Standard Solr query, no escaping applied
      def build(field, value)
        [field, value].join(":")
      end

      def unique_key(value)
        term(UniqueKeyField.instance, value)
      end
      alias_method :id, :unique_key
      alias_method :pid, :unique_key

      def negative(field, value)
        build "-#{field}", value
      end

      def present(field)
        build field, PRESENT
      end

      def absent(field)
        negative field, PRESENT
      end

      def or_values(field, values)
        build field, QueryValue.or_values(values)
      end

      def before(field, date_time)
        value = "[* TO %s]" % Ddr::Utils.solr_date(date_time)
        build field, value
      end

      def before_days(field, days)
        value = BEFORE_DAYS % days.to_i
        build field, value
      end

      def term(field, value)
        TERM % [field, value.gsub(/"/, '\"')]
      end
    end

  end
end
