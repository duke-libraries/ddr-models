require "virtus"

module Ddr::Index
  class QueryClause
    include Virtus.value_object

    ANY_FIELD = Field.new('*').freeze
    ANY_VALUE = "[* TO *]"
    QUOTE     = '"'

    TERM_QUERY      = "{!term f=%{field}}%{value}"
    STANDARD_QUERY  = "%{field}:%{value}"
    NEGATIVE_QUERY  = "-%{field}:%{value}"
    DISJUNCTION     = "{!lucene q.op=OR df=%{field}}%{value}"

    values do
      attribute :field,       FieldAttribute
      attribute :value,       String
      attribute :quote_value, Boolean, default: false
      attribute :template,    String,  default: STANDARD_QUERY
    end

    def to_s
      template % { field: field, value: quote_value ? quote(value) : value }
    end

    def quote(value)
      self.class.quote(value)
    end

    class << self

      def quote(value)
        # Derived from Blacklight::Solr::SearchBuilderBehavior#solr_param_quote
        unless value =~ /\A[a-zA-Z0-9$_\-\^]+\z/
          QUOTE + value.gsub("'", "\\\\\'").gsub('"', "\\\\\"") + QUOTE
        else
          value
        end
      end

      # Builds a query clause to retrieve the index document by unique key.
      def unique_key(value)
        term(UniqueKeyField.instance, value)
      end
      alias_method :id, :unique_key

      def where(field, value)
         values = Array(value)
        if values.size > 1
          disjunction(field, values)
        else
          new(field: field, value: values.first, quote_value: true)
        end
      end

      # Builds a query clause to filter where field does not have the given value.
      def negative(field, value)
        new(field: field, value: value, template: NEGATIVE_QUERY, quote_value: true)
      end

      # Builds a query clause to filter where field is present (i.e, has any value)
      def present(field)
        new(field: field, value: ANY_VALUE)
      end

      # Builds a query clause to filter where field is NOT present (no values)
      def absent(field)
        new(field: field, value: ANY_VALUE, template: NEGATIVE_QUERY)
      end

      # Builds a query clause to filter where field contains at least one of a set of values.
      def disjunction(field, values)
        value = values.map { |v| quote(v) }.join(" ")
        new(field: field, value: value, template: DISJUNCTION)
      end

      # Builds a query clause to filter where date field value is earlier than a date/time value.
      def before(field, value)
        new(field: field, value: "[* TO %s]" % Ddr::Utils.solr_date(value))
      end
      alias_method :before_date_time, :before

      # Builds a query clause to filter where date field value is earlier than a number of days before now.
      def before_days(field, value)
        new(field: field, value: "[* TO NOW-%iDAYS]" % value)
      end

      # Builds a "term query" clause to filter where field contains value.
      def term(field, value)
        new(field: field, value: value, template: TERM_QUERY)
      end

    end

  end
end
