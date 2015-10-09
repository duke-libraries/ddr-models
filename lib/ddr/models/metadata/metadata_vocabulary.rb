module Ddr::Models
  class MetadataVocabulary

    attr_reader :rdf_vocab

    # @param rdf_vocab [RDF::Vocabulary] an RDF vocabulary class
    def initialize(rdf_vocab)
      @rdf_vocab = rdf_vocab
    end

    # @return [Array<RDF::Vocabulary::Term>]
    def terms
      @terms ||= rdf_properties.map { |term| MetadataTerm.new(term) }
    end

    private

    def rdf_properties
      @rdf_properties ||= rdf_vocab.properties.select do |prop|
        prop.type.include?("http://www.w3.org/1999/02/22-rdf-syntax-ns#Property")
      end
    end

  end
end
