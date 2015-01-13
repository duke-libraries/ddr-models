require "rdf-vocab"

module Ddr
  module Datastreams
    class AdminMetadataDatastream < ActiveFedora::NtriplesRDFDatastream

      property :permanent_id, predicate: Ddr::Vocab::Asset.permanentId

      property :permanent_url, predicate: Ddr::Vocab::Asset.permanentUrl

      property :original_filename, predicate: RDF::Vocab::PREMIS::V1.hasOriginalName do |index|
        index.as :stored_sortable
      end

      property :workflow_state, predicate: Ddr::Vocab::Asset.workflowState

      Ddr::Vocab::Roles.each do |term|
        property Ddr::Metadata::Vocabulary.term_name(Ddr::Vocab::Roles, term), 
                 predicate: term do |index|
          index.as :symbol
        end
      end

    end
  end
end
