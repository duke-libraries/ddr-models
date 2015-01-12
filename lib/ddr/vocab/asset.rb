module Ddr
  module Vocab
    class Asset < RDF::StrictVocabulary("http://repository.lib.duke.edu/vocab/asset/")

      property "permanentId", label: "Permanent Identifier"
      property "permanentUrl", label: "Permanent URL"
      property "workflowState", label: "Workflow State"
                                  
    end
  end
end
