module Ddr::Auth
  class LegacyPermissions < AbstractLegacyPermissions

    def source
      permissions
    end

    def role_type(access)
      case access
      when "discover"
        Roles::VIEWER
      when "read"
        Roles::VIEWER
      when "edit"
        Roles::EDITOR
      end
    end

    def scope
      Roles::RESOURCE_SCOPE
    end

  end
end
