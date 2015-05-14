module Ddr
  module Auth
    module LegacyRoles
      extend ActiveSupport::Concern

      LEGACY_ROLES = [:administrator, :editor, :downloader, :contributor]

      # @return [Ddr::Auth::Roles::RoleSet]
      def legacy_downloader_to_resource_roles
        roles = adminMetadata.downloader.map do |name|
          Roles::Role.build type: Roles::DOWNLOADER, agent: name, scope: Roles::RESOURCE_SCOPE
        end
        Roles::DetachedRoleSet.new(roles)
      end

      def principal_has_role?(principal, role)
        warn "[DEPRECATION] `principal_has_role?` is deprecated and should not be used with role-based access control."
        ( principals(role) & Array(principal) ).any?
      end

      def principals(role)
        warn "[DEPRECATION] `principals(role)` is deprecated and should not be used with role-based access control." \
             " If need be, access the legacy role directly on `adminMetadata` by property name."
        if LEGACY_ROLES.include?(role)
          adminMetadata.send(role)
        else
          raise ArgumentError, "#{role.inspect} is not a legacy role."
        end
      end

    end
  end
end
