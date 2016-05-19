module Ddr::Auth
  module Roles
    extend Deprecation
    include RoleTypes

    RESOURCE_SCOPE = "resource".freeze
    POLICY_SCOPE   = "policy".freeze
    SCOPES         = [ RESOURCE_SCOPE, POLICY_SCOPE ].freeze

    class << self
      def const_missing(name)
        if [:Role,
            :RoleAttribute,
            :RoleSet,
            :RoleSetManager,
            :RoleSetQuery,
            :RoleType,
            :RoleTypes,
            :RoleValidator,
           ].include?(name)
          Deprecation.warn(Ddr::Auth::Roles,
                           "`Ddr::Auth::Roles::#{name}` has moved to `Ddr::Auth::#{name}`." \
                           " Please update your code to use the new location." \
                           " (called from #{caller.first})")
          Ddr::Auth.const_get(name)
        else
          super
        end
      end

      def type_map
        @type_map ||= role_types.map { |role_type| [role_type.to_s, role_type] }.to_h
      end

      def role_types
        @role_types ||= RoleTypes.constants(false).map { |const| RoleTypes.const_get(const) }
      end
    end

  end
end
