module Ddr::Auth
  module Roles
    class RoleSetManager

      attr_reader :object
      attr_accessor :role_set

      def initialize(object)
        @object = object
        load
      end

      def grant(*roles)
        granted = RoleSet.new(roles: roles)
        role_set.merge(granted)
        persist
      end

      def granted?(role)
        if role.is_a?(Role)
          role_set.include?(role)
        else
          granted? Role.new(role)
        end
      end

      def revoke(*roles)
        revoked = RoleSet.new(roles: roles)
        role_set.roles -= revoked.roles
        persist
      end

      def revoke_all
        role_set.clear
        persist
      end

      def replace(*roles)
        self.role_set = RoleSet.new(roles: roles)
        persist
      end

      protected

      def respond_to_missing?(name, include_all=false)
        role_set.respond_to?(name, include_all)
      end

      def method_missing(name, *args, &block)
        if role_set.respond_to?(name)
          return role_set.send(name, *args, &block)
        end
        super
      end

      private

      def persist
        object.access_roles = role_set.to_json
      end

      def load
        self.role_set = RoleSet.from_json(object.access_roles)
      end

    end
  end
end
