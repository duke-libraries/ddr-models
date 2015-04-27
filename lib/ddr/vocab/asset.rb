 module Ddr
  module Vocab
    class Asset < RDF::StrictVocabulary("http://repository.lib.duke.edu/vocab/asset/")

      property "order",
        label: "Order"

      property "permanentId",
        label: "Permanent Identifier"

      property "permanentUrl",
        label: "Permanent URL"

      property "fileGroup",
        label: "File Group"

      property "fileUse",
        label: "File Use"

      property "workflowState",
        label: "Workflow State"

    end
  end
end
