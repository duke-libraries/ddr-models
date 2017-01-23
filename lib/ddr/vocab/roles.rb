module Ddr::Vocab
  class Roles < RDF::StrictVocabulary("#{BASE_URI}/roles/")

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

  end
end
