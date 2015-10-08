module Ddr::Auth
  module Roles
    extend ActiveSupport::Autoload

    autoload :DetachedRoleSet
    autoload :PropertyRoleSet
    autoload :Role
    autoload :RoleSet
    autoload :RoleSetQuery
    autoload :RoleType
    autoload :RoleTypes

    include RoleTypes

    RESOURCE_SCOPE = "resource".freeze
    POLICY_SCOPE = "policy".freeze
    SCOPES = [RESOURCE_SCOPE, POLICY_SCOPE].freeze

    class << self

      def type_map
        @type_map ||= role_types.map { |role_type| [role_type.to_s, role_type] }.to_h
      end

      def role_types
        @role_types ||= RoleTypes.constants(false).map { |const| RoleTypes.const_get(const) }
      end

    end

  end
end
