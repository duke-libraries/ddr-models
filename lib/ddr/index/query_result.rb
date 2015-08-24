module Ddr::Index
  class QueryResult

    MAX_ROWS = 10**7

    attr_reader :query, :conn
    delegate :params, to: :query

    def initialize(query)
      @query = query
      @conn = Connection.new
    end

    def count
      response = conn.select(params, rows: 0)
      response.num_found
    end

  end
end
