module Ddr::Index
  class AbstractQueryResult
    include Enumerable

    attr_reader :query, :conn
    delegate :params, to: :query

    def initialize(query)
      @query = query.dup.freeze
      @conn = Connection.new
    end

    def count
      response = conn.select(params, rows: 0)
      response.num_found
    end

    def each
      raise NotImplementedError, "Subclasses must implement `#each`."
    end

  end
end
