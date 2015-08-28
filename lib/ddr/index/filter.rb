module Ddr::Index
  class Filter

    class << self
      delegate :where, :raw, :before_days, :before, :present, :absent, to: :new
    end

    attr_accessor :clauses

    def initialize
      @clauses = [ ]
    end

    def where(conditions)
      clauses = conditions.map do |field, value|
        if value.respond_to?(:each)
          QueryClause.or_values(field, *value)
        else
          QueryClause.term(field, value)
        end
      end
      raw *clauses
    end

    # Adds clause (String) w/o escaping
    def raw(*clauses)
      self.clauses += clauses
      self
    end

    def present(field)
      raw QueryClause.present(field)
    end

    def absent(field)
      raw QueryClause.absent(field)
    end

    def before(field, date_time)
      raw QueryClause.before(field, date_time)
    end

    def before_days(field, days)
      raw QueryClause.before_days(field, days)
    end

  end
end
