module Ddr
  module Datastreams
    class PreservationMetadataDatastream < ActiveFedora::NtriplesRDFDatastream

      property :permanent_id, 
      predicate: Ddr::Vocab::Preservation.permanentId

      property :permanent_url, 
      predicate: Ddr::Vocab::Preservation.permanentUrl

    end
  end
end
