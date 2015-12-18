require "virtus"
require "forwardable"

module Ddr::Index
  class Query
    include Virtus.model
    extend Forwardable

    attribute :q,       String
    attribute :fields,  Array[FieldAttribute], default: [ ]
    attribute :filters, Array[Filter],         default: [ ]
    attribute :sort,    Array[String],         default: [ ]
    attribute :rows,    Integer

    delegate [:count, :docs, :pids, :each_pid, :all] => :result
    delegate :params => :query_params

    def inspect
      "#<#{self.class.name} q=#{q.inspect}, filters=#{filters.inspect}," \
      " sort=#{sort.inspect}, rows=#{rows.inspect}, fields=#{fields.inspect}>"
    end

    def to_s
      URI.encode_www_form(params)
    end

    def result
      QueryResult.new(self)
    end

    def csv(**opts)
      CSVQueryResult.new(self, **opts)
    end

    def filter_clauses
      filters.map(&:clauses).flatten
    end

    def query_params
      QueryParams.new(self)
    end

  end
end
