module Ddr
  module Auth
    module Roles
      extend ActiveSupport::Autoload

      autoload :Role
      autoload :RoleSet
      autoload :RoleType
      autoload :RoleTypes
      autoload :Query      

      include RoleTypes

      RESOURCE_SCOPE = "resource"
      POLICY_SCOPE = "policy"
      SCOPES = [RESOURCE_SCOPE, POLICY_SCOPE].freeze

      class << self
        def type_map
          @type_map ||= role_types.map { |role_type| [role_type.to_s, role_type] }.to_h
        end

        def role_types
          @role_types ||= RoleTypes.constants.map { |const| RoleTypes.const_get(const) }
        end
      end

    end
  end
end
