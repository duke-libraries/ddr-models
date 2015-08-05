module Ddr::Auth
  class LegacyDefaultPermissions < AbstractLegacyPermissions

    def source
      default_permissions
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

    def clear
      defaultRights.clear_permissions!
      defaultRights.content = defaultRights.to_xml
    end

    def inspect
      "DEFAULT PERMISSIONS: #{source.inspect}"
    end

  end
end
