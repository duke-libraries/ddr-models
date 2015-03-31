module Ddr
  module Auth
    class HydraPermissions

      attr_reader :perms

      def initialize(perms)
        @perms = perms.map { |perm| HydraPermission.new(perm) }
      end

      def to_roles(scope = nil)
        perms.map { |perm| perm.to_role(scope) }
      end
      
      def to_policy_roles
        to_roles(:policy)
      end

      def to_resource_roles
        to_roles(:resource)
      end

    end
  end
end
