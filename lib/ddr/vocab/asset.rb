module Ddr::Vocab
  class Asset < RDF::StrictVocabulary("http://repository.lib.duke.edu/vocab/asset/")

    property "permanentId",
             label: "Permanent Identifier"

    property "permanentUrl",
             label: "Permanent URL"

    property "workflowState",
             label: "Workflow State"

    property "adminSet",
             label: "Administrative Set",
             comment: "A name under which objects (principally collections) are grouped for administrative purposes."

    property "eadId",
             label: "EAD ID"

    property "archivesSpaceId",
             label: "ArchivesSpace Identifier"

    property "isLocked",
             label: "Is Locked?"

    property "ingestedBy",
             label: "Ingested By",
             comment: "The agent (person or software) that initiated or performed the ingestion of the object."

    property "ingestionDate",
             label: "Ingestion Date",
             comment: "The date/time at which the object was originally ingested into the repository."

  end
end
