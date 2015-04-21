module Ddr
  module Managers
    class AbstractRoleManager < Manager

      delegate :granted?, :where, to: :granted

      def granted
        raise NotImplementedError, "Subclasses must implement `granted'."
      end

      # Return a list of the permissions granted in scope to any of the agents
      def permissions_in_scope_for_agents(scope, agents)
        where(scope: scope, agent: agents).map(&:permissions).flatten.uniq
      end

      # Return a list of the permissions granted in resource scope to any of the agents
      def resource_permissions_for_agents(agents)
        permissions_in_scope_for_agents("resource", agents)
      end

      # Return a list of the permissions granted in policy scope to any of the agents
      def policy_permissions_for_agents(agents)
        permissions_in_scope_for_agents("policy", agents)
      end

      # Return the permissions granted to the user in resource scope (via roles on the object)
      def resource_permissions_for_user(user)
        resource_permissions_for_agents(user.agents)
      end

      # Return the permissions granted to the user in policy scope (via roles on the object)
      def policy_permissions_for_user(user)
        policy_permissions_for_agents(user.agents)
      end

      # Return the permissions granted to the user on the object in resource scope, plus
      # the permissions granted to the user on the object's admin policy in policy scope
      def role_based_permissions(user)
        perms = resource_permissions_for_user(user)
        if policy = object.admin_policy
          perms |= policy.roles.policy_permissions_for_user(user)
        end
        perms
      end

    end
  end
end
