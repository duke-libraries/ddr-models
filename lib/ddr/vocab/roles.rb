module Ddr
  module Vocab
    class Roles < RDF::StrictVocabulary("http://repository.lib.duke.edu/vocab/roles/")

      term :Role,
        label: "Role",
        comment: "A role granted to an agent."
        # type: "rdfs:Class"
        # subClassOf: "http://www.w3.org/ns/auth/acl#Authorization"

      term :Owner,
        label: "Owner",
        comment: "The Owner role conveys ultimate responsibility for a resource."
        # type: "rdfs:Class"
        # subClassOf: "http://repository.lib.duke.edu/vocab/roles/Role"

      term :Curator,
        label: "Curator",
        comment: "The Curator role conveys responsibility for curating a resource and delegating responsibilities to other agents."
        # type: "rdfs:Class"
        # subClassOf: "http://repository.lib.duke.edu/vocab/roles/Role"

      term :Editor,
        label: "Editor",
        comment: "The Editor role conveys reponsibility for managing the content, description and structural arrangement of a resource."
        # type: "rdfs:Class"
        # subClassOf: "http://repository.lib.duke.edu/vocab/roles/Role"

      term :MetadataEditor,
        label: "Metadata Editor",
        comment: "The Metadata Editor role conveys responsibility for managing the description of a resource."
        # type: "rdfs:Class"
        # subClassOf: "http://repository.lib.duke.edu/vocab/roles/Role"

      term :Contributor,
        label: "Contributor",
        comment: "The Contributor role conveys responsibility for adding related resources to a resource, such as works to a collection."
        # type: "rdfs:Class"
        # subClassOf: "http://repository.lib.duke.edu/vocab/roles/Role"

      term :Downloader,
        label: "Downloader",
        comment: "The Downloader role conveys access to the original content (\"master\" file) of a resource."
        # type: "rdfs:Class"
        # subClassOf: "http://repository.lib.duke.edu/vocab/roles/Role"

      term :Viewer,
        label: "Viewer",
        comment: "The Viewer role conveys access to the description and \"access\" content derivatives of a resource."
        # type: "rdfs:Class"
        # subClassOf: "http://repository.lib.duke.edu/vocab/roles/Role"

      property :hasRole,
        label: "Has Role"
        # type: "rdf:Property"
        # domain: "rdfs:Class"
        # range: "http://repository.lib.duke.edu/vocab/roles/Role"

      property :agent,
        label: "Agent",
        comment: "The agent to whom the role is granted."
        # type: "rdf:Property"
        # domain: "http://repository.lib.duke.edu/vocab/roles/Role"
        # range: "foaf:Agent"

      property :scope,
        label: "Scope",
        comment: "The scope within which the role applies."
        # type: "rdf:Property"
        # domain: "http://repository.lib.duke.edu/vocab/roles/Role"
        # range: "http://repository.lib.duke.edu/vocab/scopes/Scope"

      #
      # Deprecated terms
      #

      term :administrator, label: "Administrator"
      term :editor, label: "Editor"
      term :contributor, label: "Contributor"
      term :downloader, label: "Downloader"

    end
  end
end
