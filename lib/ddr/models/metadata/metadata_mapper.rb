module Ddr::Models
  #
  # Maps vocabulary terms to names
  #
  class MetadataMapper
    extend MetadataMappers

    attr_reader :mapping

    # param vocab [MetadataVocabulary] the vocabulary
    def initialize(vocab)
      @mapping = vocab.terms.each_with_object({}) do |term, memo|
        memo[term.qualified_name] = term
      end
    end

    def terms
      mapping.values
    end

    def unqualified_names
      mapping.values.map(&:unqualified_name)
    end

    def merge(other)
      merged = self.dup
      merged.mapping.merge! other.mapping
      merged
    end

  end
end
