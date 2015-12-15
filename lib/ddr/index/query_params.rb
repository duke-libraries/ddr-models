require "delegate"

module Ddr::Index
  class QueryParams < SimpleDelegator

    attr_reader :params

    def initialize(query)
      super
      @params = {
        q:    q,
        fq:   fq,
        fl:   fields.join(","),
        sort: sort.join(","),
        rows: rows,
      }.select { |k, v| v.present? }
    end

    def fq
      filters.map(&:clauses).flatten
    end

  end
end
