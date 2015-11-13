 module Ddr
  module Vocab
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

    end
  end
end
