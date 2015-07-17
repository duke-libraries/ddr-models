module Ddr
  module Vocab
    class Display < RDF::StrictVocabulary("http://repository.lib.duke.edu/vocab/display/")

      property "format",
        label: "Display Format",
        comment: "Format to use when displaying the object."

    end
  end
end