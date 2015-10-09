module Ddr::Models
  #
  # Maps vocaulary terms to names
  #
  class MetadataMapper

    attr_reader :vocab

    def initialize(rdf_vocab)
      @vocab = MetadataVocabulary.new(rdf_vocab)
    end

    def mapping
      @mapping ||= vocab.terms.each_with_object({}) do |term, memo|
        memo[term.qualified_name] = term
      end
    end

  end
end
