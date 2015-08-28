module Ddr::Index
  class QueryBuilder

    def self.build
      builder = new
      yield builder
      builder.query
    end

    def initialize
      @q       = nil
      @fields  = [ Fields::PID ]
      @filters = [ ]
      @sort    = [ ]
      @rows    = nil
    end

    def query
      Query.new.tap do |qry|
        instance_variables.each do |var|
          qry.instance_variable_set(var, instance_variable_get(var))
        end
      end
    end

    def filter(*fltrs)
      @filters.push *fltrs
      self
    end

    def fields(*flds)
      @fields.push *flds
      self
    end

    def limit(num)
      @rows = num
      self
    end

    def order_by(field, order)
      @sort << [field, order].join(" ")
      self
    end

    def asc(field)
      order_by field, "asc"
    end

    def desc(field)
      order_by field, "desc"
    end

    def q(q)
      @q = q
      self
    end

    protected

    def method_missing(name, *args, &block)
      if Filter.respond_to? name
        return filter Filter.send(name, *args, &block)
      end
      super
    end

  end
end
