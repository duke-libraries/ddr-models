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
    autoload :LegacyLicenseFields
    autoload :Queries
    autoload :Query
    autoload :QueryBuilder
    autoload :QueryClause
    autoload :QueryParams
    autoload :QueryResult
    autoload :QueryValue
    autoload :Response
    autoload :SortOrder
    autoload :UniqueKeyField

    def self.pids
      builder = QueryBuilder.new { field UniqueKeyField.instance }
      query = builder.query
      query.pids
    end

  end
end
