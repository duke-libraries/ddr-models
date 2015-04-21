module Ddr
  module Managers
    class RoleManager < AbstractRoleManager

      delegate :grant, :revoke, :replace, :revoke_all, to: :granted
      delegate :access_role, :downloader, to: :data_source

      def granted
        @granted ||= Ddr::Auth::Roles::RoleSet.new(access_role)
      end
      
      # Revoke all roles in policy scope
      def revoke_policy_roles
        revoke *(where(scope: "policy"))
      end

      # Revoke all role in resource scope
      def revoke_resource_roles
        revoke *(where(scope: "resource"))
      end

      # Return a hash of role information to index
      # @return [Hash] the fields
      def index_fields
        fields = {Ddr::IndexFields::ACCESS_ROLE => granted.serialize(:json)}
        granted.each_with_object(fields) do |role, f|
          scope_field = "#{role.scope.first}_role_sim"
          f[scope_field] ||= []
          f[scope_field] |= [role.agent.first]
        end
      end

      private

      def data_source
        object.adminMetadata
      end

    end
  end
end
