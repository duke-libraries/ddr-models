require "delegate"

module Ddr::Auth
  class AbstractLegacyPermissions < SimpleDelegator

    def to_roles
      source.each_with_object(Roles::DetachedRoleSet.new) do |perm, role_set|
        role_set.grant(role(perm))
      end
    end

    def role(permission)
      Roles::Role.build type: role_type(permission[:access]), agent: permission[:name], scope: scope
    end

  end
end
