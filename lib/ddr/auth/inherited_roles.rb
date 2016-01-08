require "delegate"

module Ddr::Auth
  class InheritedRoles < SimpleDelegator

    def self.call(obj)
      new(obj).call
    end

    def call
      if has_admin_policy?
        admin_policy.roles.in_policy_scope.result
      else
        Roles::RoleSet.new
      end
    end

  end
end
