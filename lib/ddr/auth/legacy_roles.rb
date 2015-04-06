module Ddr
  module Auth
    module LegacyRoles
      extend ActiveSupport::Concern

      warn "DEPRECATION WARNING: `Ddr::Auth::LegacyRoles` is deprecated. It should be removed when deprecated roles are no longer used."

      LEGACY_ROLES = [:administrator, :editor, :downloader, :contributor]

      def legacy_downloader_to_resource_roles
        principals(:downloader).map do |name|
          agent_type = (name =~ /@/ ? :person : :group)
          Roles::Downloader.build(agent_type=>name, :scope=>:resource)
        end
      end      

      def principal_has_role?(principal, role)
        warn "DEPRECATION WARNING: `principal_has_role?` is deprecated (old roles)."
        ( principals(role) & Array(principal) ).any?
      end

      def principals(role)
        warn "DEPRECATION WARNING: `principals` is deprecated (old roles)."
        if LEGACY_ROLES.include?(role)
          adminMetadata.send(role)
        else
          raise ArgumentError, "#{role.inspect} is not a legacy role."
        end
      end

    end
  end
end
