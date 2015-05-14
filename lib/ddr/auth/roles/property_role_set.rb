module Ddr
  module Auth
    module Roles
      #
      # Wraps a set of Roles implemented as an ActiveTriples::Term.
      #
      class PropertyRoleSet < RoleSet

        def grant(*roles)
          if roles.present?
            role_set << coerce(roles)
          end
        end
        
        # @note We have to destroy resources on the ActiveTriples::Term
        #   because Term#delete does not support isomorphism.
        # @see https://github.com/ActiveTriples/ActiveTriples/issues/42
        def revoke(*roles)
          coerce(roles).each do |role|
            if role_index = find_index(role)
              role_set[role_index].destroy
            end
          end
        end

        # @note We have to destroy resources on the
        #   ActiveTriples::Term because Term#delete does not
        #   support isomorphism.
        # @see https://github.com/ActiveTriples/ActiveTriples/issues/42
        def revoke_all
          each(&:destroy)
          self
        end

        def each(&block)
          role_set.map.each(&block)
        end

        def to_set
          map.to_set
        end

      end
    end
  end
end
