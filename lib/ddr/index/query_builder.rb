module Ddr::Index
  #
  # QueryBuilder - Provides a DSL for building a Query.
  #
  # Note: Where a method receives a [field] parameter, the parameter value is
  # coerced to a Field instance. See FieldAttribute#coerce for details.
  #
  # *** DSL METHODS ***
  #
  # absent [field]
  #   Adds a filter selecting documents where the field is not present (no values).
  #
  # asc [field], ...
  #   Adds ascending orderings by the fields specified.
  #
  #   See also: desc, order_by
  #
  # before [field], [date_time]
  #   Adds a filter selecting documents where the field has a date/time before
  #   (earlier than) the value.
  #
  # before_days [field], [int]
  #   Adds a filter selecting documents where the field has a date/time the
  #     specified number of days before today (now) or earlier.
  #
  # desc [field], ...
  #   Adds descending orderings by the fields specified.
  #
  #   See also: asc, order_by
  #
  # id [doc_id]
  #   For selecting a single document by ID.
  #
  # filter [filter1], ...
  #   Adds filters to the query.
  #
  #   Aliased as: filters
  #
  # filters [filter], ...
  #   Alias for: filter
  #
  # field [field1], ...
  #   Adds fields to result documents.
  #     Note that all fields are returned when none is specified.
  #
  #   Aliased as: fields
  #
  # fields [field], ...
  #   Alias for: field
  #
  # limit [int]
  #   Limits the number of documents returned by the query.
  #
  #   Aliased as: rows
  #
  # model [model_name], ...
  #   Adds a filter selecting document where ActiveFedora model equals value
  #     or one of the values.
  #
  # negative [field], [value]
  #   Adds a filter selecting document where field does not have the value.
  #
  # order_by [{field => order, ...}], ...
  #   Adds ordering(s) to the query.
  #
  #   Aliased as: sort
  #
  # present [field]
  #   Adds a filter selecting document where the field has any value.
  #
  # q [query_clause]
  #   Sets a query clause for the `q` parameter.
  #
  # raw [clause1], ...
  #   Adds a filter of "raw" query clauses (i.e., pre-constructed).
  #
  # rows [int]
  #   Alias for: limit
  #
  # sort [{field => order, ...}]
  #   Alias for: order_by
  #
  # term [{field => value, ...}]
  #   Adds a filter of "term" query clauses for the fields and values.
  #
  # where [{field => value, ...}]
  #   Adds a filter of "standard" query clauses.
  #     Values will be escaped when the filter is serialized.
  #     If a hash value is an array, that query clause will select documents
  #     where the field matches any array entry.
  #
  class QueryBuilder

    attr_reader :query

    def initialize(*args, &block)
      @query = args.first.is_a?(Query) ? args.shift : Query.new
      if block_given?
        instance_exec(*args, &block)
      end
    end

    # @param pid [String]
    # @return [QueryBuilder]
    def id(pid)
      q QueryClause.id(pid)
      limit 1
    end

    # @param filters [Array<Filter>]
    # @return [QueryBuilder]
    def filter(*filters)
      query.filters += filters
      self
    end
    alias_method :filters, :filter

    # @param fields [Array<Field>]
    # @return [QueryBuilder] self
    def field(*fields)
      query.fields += fields.flatten.map { |f| FieldAttribute.coerce(f) }
      self
    end
    alias_method :fields, :field

    # @param num [Integer]
    # @return [QueryBuilder] self
    def limit(num)
      query.rows = num.to_i
      self
    end
    alias_method :rows, :limit

    # @param orderings [Hash<Field, String>]
    # @return [QueryBuilder] self
    def order_by(*orderings)
      query.sort += orderings.first.map { |field, order| SortOrder.new(field: field, order: order) }
      self
    end
    alias_method :sort, :order_by

    # @param fields [Array<Field, Symbol, String>]
    # @return [QueryBuilder] self
    def asc(*fields)
      query.sort += fields.map { |field| SortOrder.asc(field) }
      self
    end
    # @param fields [Array<Field, Symbol, String>]
    # @return [QueryBuilder] self
    def desc(*fields)
      query.sort += fields.map { |field| SortOrder.desc(field) }
      self
    end

    # @param query_clause [QueryClause, String]
    # @return [QueryBuilder] self
    def q(query_clause)
      query.q = query_clause
      self
    end

    private

    def respond_to_missing?(name, include_all)
      Filter::ClassMethods.public_instance_methods.include?(name)
    end

    def method_missing(name, *args, &block)
      if respond_to?(name)
        filter Filter.send(name, *args)
      else
        super
      end
    end

  end
end
