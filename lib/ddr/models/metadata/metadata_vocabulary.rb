module Ddr::Models
  class MetadataVocabulary
    extend MetadataVocabularies

    attr_reader :rdf_vocab, :except, :only_properties

    # @param rdf_vocab [RDF::Vocabulary] an RDF vocabulary class
    # @param except [RDF::Vocabulary::Term, Array<RDF::Vocabulary::Term>] term(s) to exclude
    # @param only_properties [Boolean] whether to include only RDF properties
    #   -- i.e., having RDF type http://www.w3.org/1999/02/22-rdf-syntax-ns#Property
    #   -- default: true
    def initialize(rdf_vocab, except: nil, only_properties: true)
      @rdf_vocab = rdf_vocab
      @except = Array(except)
      @only_properties = only_properties
    end

    # @return [Array<RDF::Vocabulary::Term>]
    def terms
      @terms ||= rdf_properties.map { |term| MetadataTerm.new(term) }
    end

    private

    def rdf_properties
      props = rdf_vocab.properties
      if only_properties
        props.select! { |prop| prop.type.include?("http://www.w3.org/1999/02/22-rdf-syntax-ns#Property") }
      end
      props - except
    end

  end
end
