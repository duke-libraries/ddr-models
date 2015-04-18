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
          Array(scopes).include? role.scope.first
        end

        def any_type?(types, role)
          Array(types).include? role.role_type.first
        end

        def any_agent?(agents, role)
          Array(agents).include? role.agent.first
        end

      end
    end
  end
end
