require "delegate"

module Ddr::Auth
  class ResourceRoles < SimpleDelegator

    # @param obj [Object] an object that receives :roles and returns a RoleSet
    # @return [Ddr::Auth::Roles::RoleSetQuery]
    def self.call(obj)
      new(obj).call
    end

    # @return [Ddr::Auth::Roles::DetachedRoleSet]
    def call
      roles.in_resource_scope.detach
    end

  end
end
