module Ddr
  module Auth
    class LegacyPermissions

      attr_reader :permissions

      LEGACY_PERMISSION_ROLE_MAP = {
        "discover" => "Viewer",
        "read" => "Viewer",
        "edit" => "Editor"
      }

      def initialize(permissions)
        @permissions = permissions
      end

      def to_resource_roles
        to_roles(:resource)
      end

      def to_policy_roles
        to_roles(:policy)
      end

      def to_roles(scope)
        permissions.map do |perm|
          Roles::Role.build(type: role_type(perm), agent: perm[:name], scope: scope)
        end
      end

      private

      def role_type(perm)
        LEGACY_PERMISSION_ROLE_MAP[perm[:access]]
      end

      def agent_type(perm)
        perm[:type] == "group" ? :group : :person
      end

    end
  end
end
