module Ddr
  module Managers
    class RoleManager < Manager

      delegate :grant, :revoke, :granted?, :replace, :revoke_all, :where, to: :granted
      delegate :downloader, to: :ds

      def granted
        @granted ||= Ddr::Auth::Roles::RoleSet.new(ds.access_role)
      end
      
      # Revoke all roles in policy scope
      def revoke_policy_roles
        revoke *(where(scope: "policy"))
      end

      # Revoke all role in resource scope
      def revoke_resource_roles
        revoke *(where(scope: "resource"))
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

      # Return a hash of role information to index
      # @return [Hash] the fields
      def index_fields
        granted.each_with_object({}) do |role, fields|
          scope_field = scope_index_field(role)
          fields[scope_field] ||= []
          fields[scope_field] |= [role.agent.first]
          scope_role_field = scope_role_index_field(role)
          fields[scope_role_field] ||= []
          fields[scope_role_field] << role.agent.first
        end
      end
      
      private

      def scope_index_field(role)
        "#{role.scope.first}_role_sim"
      end

      def scope_role_index_field(role)
        "#{role.scope.first}_#{role.role_type.first.underscore}_role_ssim"
      end

      def ds
        object.adminMetadata
      end

    end
  end
end
