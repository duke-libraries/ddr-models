module Ddr
  module Metadata
    extend ActiveSupport::Autoload

    autoload :DukeTerms
    autoload :PremisEvent
    autoload :RDFVocabularyParser
    autoload :RolesVocabulary
    autoload :Vocabulary

    RDF_RELATIONS_URI = "http://repository.lib.duke.edu/rdf/relations#"

    PREDICATES = {
      RDF_RELATIONS_URI => {
        is_representation_of: "isRepresentationOf"
      },
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
