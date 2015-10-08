module Ddr::Models
  class DescriptiveMetadata < Metadata

    class_attribute :vocabularies
    self.vocabularies = { dcterms: RDF::DC, duketerms: Ddr::Vocab::DukeTerms }.freeze

    def self.indexers
      # Add term_name => [indexers] mapping to customize indexing
      {}
    end

    def self.default_indexers
      [:stored_searchable]
    end

    def self.indexers_for(term_name)
      indexers.fetch(term_name, default_indexers)
    end

    # Add terms from the vocabularies as properties
    def self.set_properties(klass)
      vocabularies.each do |prefix, vocab|
        Ddr::Vocab::Vocabulary.property_terms(vocab).each do |term|
          term_name = [ prefix, Ddr::Vocab::Vocabulary.term_name(vocab, term) ].join('_').to_sym
          klass.property term_name, predicate: term do |index|
            index.as *indexers_for(term_name)
          end
        end
      end
    end

  end
end
