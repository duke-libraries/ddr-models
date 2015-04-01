require "delegate"

module Ddr
  module Auth
    module Roles
      class Query < SimpleDelegator

        def initialize(role_set)
          super(role_set.to_a)
        end

        def where(criteria)
          matching = select do |role|
            criteria.all? do |key, value|
              send("any_#{key}?", value, role)
            end
          end
          __setobj__(matching)
          self
        end

        private

        def any_scope?(scopes, role)
          Array(scopes).any? do |scope|
            scope == (scope.is_a?(RDF::URI) ? role.get_scope : role.scope_type)
          end
        end

        def any_type?(types, role)
          Array(types).any? { |t| t == role.role_type }
        end

        def any_person?(persons, role)
          role.person_agent? ? any_agent?(persons, role) : false
        end

        def any_group?(groups, role)
          role.group_agent? ? any_agent?(groups, role) : false
        end

        def any_agent?(agents, role)
          unless agents.is_a?(Array)
            agents = [agents]
          end
          agents.any? do |agent|
            agent == (agent.is_a?(Ddr::Auth::Agent) ? role.get_agent : role.agent_name)
          end
        end

      end
    end
  end
end
