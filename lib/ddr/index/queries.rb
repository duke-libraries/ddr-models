module Ddr::Index
  module Queries

    # Returns a query for a single index document.
    # @param doc_id [String] the index document id
    # @return [Query] the query
    def self.id(doc_id)
      builder = QueryBuilder.new { id doc_id }
      builder.query
    end

    # Returns a query for the index document for an object.
    # @param obj [ActiveFedora::Base] the object
    # @return [Query] the query
    def self.object(obj)
      id(obj.pid)
    end

  end
end
