require "forwardable"

module Ddr::Index
  class Filter

    class << self
      extend Forwardable

      def_delegators :new, :raw, :where, :absent, :present, :negative, :before, :before_days
    end

    attr_accessor :clauses

    def initialize(clauses = nil)
      @clauses = Array(clauses)
    end

    # Adds clause (String) w/o escaping
    def raw(*clauses)
      self.clauses.push *clauses
      self
    end

    def where(conditions)
      clauses = conditions.map do |field, value|
        values = Array(value)
        if values.size > 1
          QueryClause.or_values(field, values)
        else
          QueryClause.term(field, values.first)
        end
      end
      raw *clauses
    end

    def absent(*args)
      raw QueryClause.absent(*args)
    end

    def present(*args)
      raw QueryClause.present(*args)
    end

    def negative(*args)
      raw QueryClause.negative(*args)
    end

    def before(*args)
      raw QueryClause.before(*args)
    end

    def before_days(*args)
      raw QueryClause.before_days(*args)
    end

    def ==(other)
      other.instance_of?(self.class) && (other.clauses == self.clauses)
    end

  end
end
