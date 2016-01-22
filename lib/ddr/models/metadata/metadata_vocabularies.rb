module Ddr::Models
  # Registry of common metadata vocabularies
  module MetadataVocabularies

    def dc11
      MetadataVocabulary.new(RDF::Vocab::DC11)
    end

    def dcterms
      MetadataVocabulary.new(RDF::Vocab::DC, except: RDF::Vocab::DC.license)
    end

    def duketerms
      MetadataVocabulary.new(Ddr::Vocab::DukeTerms)
    end

  end
end
