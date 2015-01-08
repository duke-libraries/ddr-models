module Ddr
  module Datastreams
    class AdminMetadataDatastream < ActiveFedora::NtriplesRDFDatastream

      property :permanent_id, predicate: Ddr::Vocab::Asset.permanentId

      property :permanent_url, predicate: Ddr::Vocab::Asset.permanentUrl

      Ddr::Vocab::Roles.each do |term|
        property Ddr::Metadata::Vocabulary.term_name(Ddr::Vocab::Roles, term), 
                 predicate: term do |index|
          index.as :symbol
        end
      end

    end
  end
end
