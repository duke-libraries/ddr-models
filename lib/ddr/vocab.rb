require "rdf/vocab"

module Ddr
  module Vocab
    extend ActiveSupport::Autoload

    BASE_URI = "http://repository.lib.duke.edu/vocab"

    PREMIS = begin
               RDF::Vocab::PREMIS::V1
             rescue NameError
               RDF::Vocab::PREMIS
             end

    autoload :Asset
    autoload :Display
    autoload :DukeTerms
    autoload :RDFVocabularyParser
    autoload :Roles
    autoload :Vocabulary

  end
end
