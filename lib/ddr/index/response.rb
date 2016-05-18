require "delegate"

module Ddr::Index
  #
  # Wraps an index query response
  #
  class Response < SimpleDelegator

    def docs
      response["docs"]
    end

    def num_found
      response["numFound"].to_i
    end

    def facet_counts
      self["facet_counts"] || {}
    end

    def facet_fields
      facet_counts["facet_fields"] || {}
    end

    def response
      self["response"]
    end

  end
end
