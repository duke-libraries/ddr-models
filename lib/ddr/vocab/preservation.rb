module Ddr
  module Vocab
    class Preservation < RDF::StrictVocabulary("http://repository.lib.duke.edu/vocab/preservation/")

      property "permanentId", 
      label: "Permanent Identifier",
      subPropertyOf: RDF::DC.identifier
      
      property "permanentUrl",
      label: "Permanent URL"
                                  
    end
  end
end
