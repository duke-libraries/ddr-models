module Ddr::Models
  class ExternalFile < ActiveTriples::Resource

    configure type: RDF::Vocab::PREMIS.File

    property :use, predicate: Ddr::Vocab::Asset.use
    property :location, predicate: Ddr::Vocab::Asset.location
    property :mime_type, predicate: RDF::DC.format 

  end
end
