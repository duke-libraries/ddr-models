require "delegate"

module Ddr::Models
  # Wraps an RDF term (RDF::Vocabulary::Term)
  class MetadataTerm < SimpleDelegator

    def qualified_name
      qname.join("_").to_sym
    end

    def unqualified_name
      qname.last
    end

    def predicate
      to_uri
    end

    def prefix
      qname.first
    end

  end
end
