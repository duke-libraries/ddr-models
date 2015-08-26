module Ddr::Index
  class QueryBuilder

    attr_accessor :q, :fields, :filters, :sort, :limit

    def initialize
      @q       = "*:*"
      @fields  = [ Fields::PID ]
      @filters = [ ]
      @sort    = [ ]
      @limit   = nil
    end

    def query
      Query.new.tap do |qry|
        instance_variables.each do |var|
          qry.instance_variable_set(var, instance_variable_get(var))
        end
      end
    end

    def filter(*filters)
      self.filters += filters
      self
    end

    def fields(*fields)
      self.fields += fields
      self
    end
    alias_method :field, :fields

    def limit(num)
      self.limit = num
      self
    end

    def sort(*orderings)
      self.sort += orderings
      self
    end

    # @param conditions [Hash]
    def where(conditions)
      filter Filter.where(conditions)
    end

    # for adding raw string filters
    def raw(*clauses)
      filter Filter.raw(*clauses)
    end

    def q(q)
      self.q = q
      self
    end

  end
end
