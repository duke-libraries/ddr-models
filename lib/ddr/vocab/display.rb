module Ddr::Vocab
  class Display < RDF::StrictVocabulary("#{BASE_URI}/display/")

    property "format",
             label: "Display Format",
             comment: "Format to use when displaying the object."

  end
end
