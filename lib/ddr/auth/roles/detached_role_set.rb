require "set"

module Ddr
  module Auth
    module Roles
      #
      # Wraps a set of Roles detached from a repository object
      #
      class DetachedRoleSet < RoleSet

        delegate :each, to: :role_set
        
        class << self
          # Deserialize a serialized RoleSet into a DetachedRoleSet
          def deserialize(serialized)
            role_set = serialized.map { |role_data| Role.deserialize(role_data) }
            new(role_set)
          end

          # Deserialize a JSON representation of a set of Roles into a DetachedRoleSet
          def from_json(json)
            deserialize JSON.parse(json)
          end
        end

        attr_writer :role_set

        def initialize(role_set = Set.new)
          super role_set.to_set
        end

        def grant(*roles)
          role_set.merge coerce(roles)
        end

        def revoke(*roles)
          self.role_set -= coerce(roles)
        end

        def revoke_all
          clear
        end

        def to_a
          role_set.to_a
        end

        # Merges the roles from another role set into the role set
        # @param other [Enumerable<Role>]
        # @return [DetachedRoleSet] self
        def merge(other)
          role_set.merge other
          self
        end

      end
    end
  end
end
