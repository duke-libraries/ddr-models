module Ddr
  module Datastreams
    class DescriptiveMetadataDatastream < MetadataDatastream

      class_attribute :vocabularies
      self.vocabularies = [RDF::DC, Ddr::Vocab::DukeTerms].freeze

      def self.default_attributes
        super.merge(:mimeType => 'application/n-triples')
      end

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
      vocabularies.each do |vocab|
        Ddr::Vocab::Vocabulary.property_terms(vocab).each do |term|
          term_name = Ddr::Vocab::Vocabulary.term_name(vocab, term)
          # Do not include :license as a descriptive metadata property
          unless term_name == :license
            property term_name, predicate: term do |index|
              index.as *indexers_for(term_name)
            end
          end
        end
      end

      # Override ActiveFedora::Rdf::Indexing#apply_prefix(name) to not
      # prepend the index field name with a string based on the datastream id.
      def apply_prefix(name)
        name
      end

    end
  end
end
