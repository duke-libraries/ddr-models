require "rdf/vocab"

module Ddr
  module Datastreams
    class AdministrativeMetadataDatastream < MetadataDatastream

      property :permanent_id,
               predicate: Ddr::Vocab::Asset.permanentId

      property :permanent_url,
               predicate: Ddr::Vocab::Asset.permanentUrl

      property :original_filename,
               predicate: Ddr::Vocab::PREMIS.hasOriginalName do |index|
        index.as :stored_sortable
      end

      property :workflow_state,
               predicate: Ddr::Vocab::Asset.workflowState

      property :access_role,
               predicate: Ddr::Vocab::Roles.hasRole,
               class_name: Ddr::Auth::Roles::Role

      property :local_id,
               predicate: RDF::Vocab::Identifiers.local

      property :admin_set,
               predicate: Ddr::Vocab::Asset.adminSet

      property :display_format,
               predicate: Ddr::Vocab::Display.format

      property :research_help_contact,
               predicate: Ddr::Vocab::Contact.assistance

      property :depositor,
               predicate: RDF::Vocab::MARCRelators.dpt

      property :doi,
               predicate: RDF::Vocab::Identifiers.doi

      property :license,
               predicate: RDF::DC.license

      property :ead_id,
               predicate: Ddr::Vocab::Asset.eadId

      property :aspace_id,
               predicate: Ddr::Vocab::Asset.archivesSpaceId

      property :is_locked,
               predicate: Ddr::Vocab::Asset.isLocked

      property :ingested_by,
               predicate: Ddr::Vocab::Asset.ingestedBy

      property :ingestion_date,
               predicate: Ddr::Vocab::Asset.ingestionDate

      property :rights_note,
               predicate: Ddr::Vocab::Asset.rightsNote

    end
  end
end
