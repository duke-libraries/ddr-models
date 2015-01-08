module Ddr
  module Vocab
    class Asset < RDF::StrictVocabulary("http://repository.lib.duke.edu/vocab/asset/")

      property "permanentId", 
      label: "Permanent Identifier",
      subPropertyOf: RDF::DC.identifier
      
      property "permanentUrl",
      label: "Permanent URL"
                                  
    end
  end
end
