module Ddr
  module Auth
    class LegacyPermissions

      attr_reader :permissions

      LEGACY_PERMISSION_ROLE_MAP = {
        "discover" => Roles::VIEWER,
        "read"     => Roles::VIEWER,
        "edit"     => Roles::EDITOR
      }

      def initialize(permissions)
        @permissions = permissions
      end

      def to_resource_roles
        to_roles(Roles::RESOURCE_SCOPE)
      end

      def to_policy_roles
        to_roles(Roles::POLICY_SCOPE)
      end

      # @param scope [String] the scope to assign to each role
      # @return [Ddr::Auth::Roles::RoleSet]
      def to_roles(scope)
        roles = permissions.map do |perm|
          access, agent = perm[:access], perm[:name]
          Roles::Role.build type: LEGACY_PERMISSION_ROLE_MAP[access],
                            agent: agent,
                            scope: scope
        end
        Roles::DetachedRoleSet.new(roles)
      end

    end
  end
end
