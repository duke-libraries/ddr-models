module Ddr::Models
  module Describable
    extend ActiveSupport::Concern

    included do
      DescriptiveMetadata.mapping.each do |name, term|
        property name, predicate: term.predicate do |index|
          index.as :stored_searchable
        end
      end
    end

    def descMetadata
      @descMetadata ||= DescriptiveMetadata.new(self)
    end

    def has_desc_metadata?
      descMetadata.has_content?
    end

    def desc_metadata_terms *args
      return DescriptiveMetadata.unqualified_names.sort if args.empty?
      arg = args.pop
      terms = case arg.to_sym
              when :empty
                desc_metadata_terms.select { |t| desc_metadata_values(t).empty? }
              when :present
                desc_metadata_terms.select { |t| desc_metadata_values(t).present? }
              when :defined_attributes
                desc_metadata_terms & desc_metadata_attributes
              when :required
                desc_metadata_terms(:defined_attributes).select {|t| required? t}
              when :dcterms
                MetadataMapping.dc11.unqualified_names +
                  (MetadataMapping.dcterms.unqualified_names - MetadataMapping.dc11.unqualified_names)
              when :dcterms_elements11
                Ddr::Vocab::Vocabulary.term_names(RDF::DC11)
              when :duke
                Ddr::Vocab::Vocabulary.term_names(Ddr::Vocab::DukeTerms)
              else
                raise ArgumentError, "Invalid argument: #{arg.inspect}"
              end
      if args.empty?
        terms
      else
        terms | desc_metadata_terms(*args)
      end
    end

    def desc_metadata_attributes
      MetadataMapping.dc11.unqualified_names
    end

    def desc_metadata_values(term)
      descMetadata.values term
    end

    def desc_metadata_vocabs
      descMetadata.class.vocabularies
    end

    def set_desc_metadata_values(term, values)
      descMetadata.set_values term, values
    end

    # Update all descMetadata terms with values in hash
    # Note that term not having key in hash will be set to nil!
    def set_desc_metadata(term_values_hash)
      desc_metadata_terms.each { |t| set_desc_metadata_values(t, term_values_hash[t]) }
    end

    module ClassMethods
      def find_by_identifier(identifier)
        find(Ddr::Index::Fields::IDENTIFIER_ALL => identifier)
      end
    end

  end
end
