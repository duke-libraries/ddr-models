require "delegate"

module Ddr::Auth
  class InheritedRoles < SimpleDelegator

    # @param obj [Object] an object that receives :roles and returns a RoleSet
    # @return [Ddr::Auth::Roles::RoleSetQuery]
    def self.call(obj)
      new(obj).call
    end

    # @return [Ddr::Auth::Roles::DetachedRoleSet]
    def call
      if has_admin_policy?
        admin_policy.roles.in_policy_scope.detach
      else
        Roles::DetachedRoleSet.new
      end
    end

  end
end
