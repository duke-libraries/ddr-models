module Ddr::Index
  class QueryParams

    attr_reader :query

    def initialize(query)
      @query = query
    end

    def params
      { q:    q_param,
        fq:   filter_queries,
        fl:   fields,
        sort: sort,
        rows: rows,
      }.select { |k, v| v.present? }
    end

    def q_param
      query.q.to_s
    end

    def filter_queries
      query.filter_clauses.map(&:to_s)
    end

    def fields
      query.fields.join(",")
    end

    def sort
      query.sort.join(",")
    end

    def rows
      query.rows
    end

  end
end
