module Ddr
  module Index
    extend ActiveSupport::Autoload

    autoload :AbstractQueryResult
    autoload :Connection
    autoload :CSVQueryResult
    autoload :DocumentBuilder
    autoload :Field
    autoload :Fields
    autoload :Filter
    autoload :Filters
    autoload :Query
    autoload :QueryBuilder
    autoload :QueryClause
    autoload :QueryResult
    autoload :QueryValue
    autoload :Response
    autoload :UniqueKeyField

    def self.pids
      builder = QueryBuilder.new
      query = builder.query
      query.pids
    end

  end
end
