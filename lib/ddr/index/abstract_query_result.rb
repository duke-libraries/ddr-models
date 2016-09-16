module Ddr::Index
  class AbstractQueryResult
    include Enumerable

    attr_reader :query
    delegate :params, to: :query

    def initialize(query)
      @query = query.dup.freeze
    end

    def count
      response = Connection.select(params, rows: 0)
      response.num_found
    end

    def each
      raise NotImplementedError, "Subclasses must implement `#each`."
    end

  end
end
