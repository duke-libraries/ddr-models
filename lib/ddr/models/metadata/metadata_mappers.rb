module Ddr::Models
  # A registry of common metadata mappers
  module MetadataMappers

    def dc11
      MetadataMapper.new(MetadataVocabulary.dc11)
    end

    def dcterms
      MetadataMapper.new(MetadataVocabulary.dcterms)
    end

    def duketerms
      MetadataMapper.new(MetadataVocabulary.duketerms)
    end

  end
end
