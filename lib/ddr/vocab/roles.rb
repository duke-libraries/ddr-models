module Ddr
  module Vocab
    class Roles < RDF::StrictVocabulary("http://repository.lib.duke.edu/vocab/roles/")

      LEGACY_ROLES = [:administrator, :editor, :contributor, :downloader]

      term :Role,
        label: "Role",
        comment: "An assertion of a role granted to an agent."

      property :hasRole,
        label: "Has Role",
        comment: "Asserts the granting of a role on the subject to an agent."

      property :type,
        label: "Type",
        comment: "The type of role granted to the agent."

      property :agent,
        label: "Agent",
        comment: "The agent to whom the role is granted."

      property :scope,
        label: "Scope",
        comment: "The scope within which the role applies."

      #
      # Deprecated terms
      #

      LEGACY_ROLES.each do |legacy_role|
        term legacy_role, label: legacy_role.to_s.capitalize
      end

    end
  end
end
