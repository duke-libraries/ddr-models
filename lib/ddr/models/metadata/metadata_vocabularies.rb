module Ddr::Models
  # Registry of common metadata vocabularies
  module MetadataVocabularies

    def dc11
      MetadataVocabulary.new(RDF::DC11)
    end

    def dcterms
      MetadataVocabulary.new(RDF::DC, except: RDF::DC.license)
    end

    def duketerms
      MetadataVocabulary.new(Ddr::Vocab::DukeTerms)
    end

  end
end
