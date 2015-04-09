module Ddr
  module Vocab
    extend ActiveSupport::Autoload

    BASE_URI = "http://repository.lib.duke.edu/vocab"

    autoload :Asset
    autoload :DukeTerms
    autoload :RDFVocabularyParser
    autoload :Roles
    autoload :Vocabulary

  end
end
