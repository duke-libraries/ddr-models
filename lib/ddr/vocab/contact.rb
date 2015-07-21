module Ddr
  module Vocab
    class Contact < RDF::StrictVocabulary("http://repository.lib.duke.edu/vocab/contact/")

      property "assistance",
        label: "Research Assistance",
        comment: "Contact for research assistance with this object."

    end
  end
end
