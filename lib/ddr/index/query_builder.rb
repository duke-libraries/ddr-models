module Ddr::Index
  #
  # QueryBuilder - Provides a DSL for building a Query.
  #
  class QueryBuilder
    extend Deprecation

    # Builds a Query object
    # @yield [builder] a new QueryBuilder instance.
    # @return [Query]
    def self.build
      Deprecation.warn(self,
                       "`Ddr::Index::QueryBuilder.build` is deprecated and will be removed in ddr-models 3.0." \
                       " Use `Ddr::Index::QueryBuilder.new` instead.")
      builder = new
      yield builder
      builder.query
    end

    attr_reader :query

    def initialize(&block)
      @query = Query.new
      if block_given?
        instance_eval &block
      end
    end

    def id(pid)
      q QueryClause.id(pid)
      limit 1
    end

    def filter(*filters)
      query.filters.push(*filters)
      self
    end
    alias_method :filters, :filter

    def raw(*args)
      filter Filter.raw(*args)
    end

    def where(*args)
      filter Filter.where(*args)
    end

    def absent(*args)
      filter Filter.absent(*args)
    end

    def present(*args)
      filter Filter.present(*args)
    end

    def negative(*args)
      filter Filter.negative(*args)
    end

    def before(*args)
      filter Filter.before(*args)
    end

    def before_days(*args)
      filter Filter.before_days(*args)
    end

    def field(*fields)
      query.fields.push(*fields)
      self
    end
    alias_method :fields, :field

    def limit(num)
      query.rows = num
      self
    end
    alias_method :rows, :limit

    def order_by(*args)
      unless args.first.is_a? Hash
        Deprecation.warn(QueryBuilder, "`order_by` will require a hash of orderings in ddr-models 3.0.")
        field, order = args
        return order_by(field => order)
      end
      query.sort += args.first.map { |field, order| SortOrder.new(field: field, order: order) }
      self
    end
    alias_method :sort, :order_by

    def asc(field)
      Deprecation.warn(QueryBuilder,
                       "`asc(field)` is deprecated and will be removed from ddr-models 3.0." \
                       " Use `order_by(field => \"asc\")` instead.")
      order_by(field => SortOrder::ASC)
    end

    def desc(field)
      Deprecation.warn(QueryBuilder,
                       "`desc(field)` is deprecated and will be removed from ddr-models 3.0." \
                       " Use `order_by(field => \"desc\")` instead.")
      order_by(field => SortOrder::DESC)
    end

    def q(q)
      query.q = q
      self
    end

  end
end
