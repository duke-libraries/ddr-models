module Ddr
  module Metadata
    extend ActiveSupport::Autoload

    autoload :DukeTerms
    autoload :PremisEvent
    autoload :RDFVocabularyParser
    autoload :RolesVocabulary
    autoload :Vocabulary

    PREDICATES = {
      "http://projecthydra.org/ns/relations#" => {
        is_attached_to: "isAttachedTo"
      },
      "http://www.loc.gov/mix/v20/externalTarget#" => {
        is_external_target_for: "isExternalTargetFor",
        has_external_target: "hasExternalTarget"
      }
    }

  end
end
