module Ddr::Vocab
  class Contact < RDF::StrictVocabulary("#{BASE_URI}/contact/")

    property "assistance",
             label: "Research Assistance",
             comment: "Contact for research assistance with this object."

  end
end
