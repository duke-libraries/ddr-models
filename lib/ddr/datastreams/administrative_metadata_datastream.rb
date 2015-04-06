require "rdf-vocab"

module Ddr
  module Datastreams
    class AdministrativeMetadataDatastream < MetadataDatastream

      property :permanent_id, predicate: Ddr::Vocab::Asset.permanentId

      property :permanent_url, predicate: Ddr::Vocab::Asset.permanentUrl

      property :original_filename, predicate: RDF::Vocab::PREMIS::V1.hasOriginalName do |index|
        index.as :stored_sortable
      end

      property :workflow_state, predicate: Ddr::Vocab::Asset.workflowState

      Ddr::Vocab::Roles::LEGACY_ROLES.each do |legacy_role|
        warn "DEPRECATION WARNING: `#{legacy_role.inspect}` is a deprecated legacy role."
        property legacy_role, predicate: Ddr::Vocab::Roles.send(legacy_role) do |index|
          index.as :symbol
        end
      end

      property :access_role, predicate: Ddr::Vocab::Roles.hasRole

    end
  end
end
