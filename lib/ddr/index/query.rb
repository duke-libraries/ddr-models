require "virtus"
require "forwardable"

module Ddr::Index
  class Query
    include Virtus.model
    extend Forwardable

    attribute :q,       String
    attribute :fields,  Array[String], default: [ ]
    attribute :filters, Array[Filter], default: [ ]
    attribute :sort,    Array[String], default: [ ]
    attribute :rows,    Integer

    def_delegators :result, :count, :docs, :pids, :each_pid, :all

    def inspect
      "#<#{self.class.name} q=#{q.inspect}, filters=#{filters.inspect}," \
      " sort=#{sort.inspect}, rows=#{rows.inspect}, fields=#{fields.inspect}>"
    end

    def to_s
      URI.encode_www_form(params)
    end

    def params
      QueryParams.new(self).params
    end

    def result
      QueryResult.new(self)
    end

    def csv(**opts)
      CSVQueryResult.new(self, **opts)
    end

  end
end
