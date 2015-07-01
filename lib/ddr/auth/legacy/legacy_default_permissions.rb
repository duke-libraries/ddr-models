module Ddr::Auth
  class LegacyDefaultPermissions < AbstractLegacyPermissions

    def source
      respond_to?(:default_permissions) ? default_permissions : []
    end

    def role_type(access)
      case access
      when "discover"
        Roles::VIEWER
      when "read"
        Roles::VIEWER
      when "edit"
        Roles::CURATOR
      end
    end

    def scope
      Roles::POLICY_SCOPE
    end

  end
end
