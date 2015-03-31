module Ddr
  module Vocab
    class Scopes < RDF::StrictVocabulary("#{BASE_URI}/scopes/")

      term :Scope,
        label: "Scope",
        comment: "A scope within which an assertion or statement applies (abstract; use subclasses)."
        # type: "rdfs:Class"

      term :Resource,
        label: "Resource",
        comment: "The role applies to the resource which is the subject of the assertion."
        # type: "rdfs:Class"
        # subClassOf: "http://repository.lib.duke.edu/vocab/scopes/Scope"

      term :Policy,
        label: "Policy",
        comment: "The role applies to resources \"governed\" by the resource which is the subject of the assertion."
        # type: "rdfs:Class"
        # subClassOf: "http://repository.lib.duke.edu/vocab/scopes/Scope"

    end
  end
end
