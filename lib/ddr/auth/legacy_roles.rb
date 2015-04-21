module Ddr
  module Auth
    module LegacyRoles
      extend ActiveSupport::Concern

      LEGACY_ROLES = [:administrator, :editor, :downloader, :contributor]

      def legacy_downloader_to_resource_roles
        principals(:downloader).map do |name|
          agent_type = (name =~ /@/ ? :person : :group)
          Roles::Role.build(:type=>:downloader, agent_type=>name, :scope=>:resource)
        end
      end      

      def principal_has_role?(principal, role)
        ( principals(role) & Array(principal) ).any?
      end

      def principals(role)
        if LEGACY_ROLES.include?(role)
          adminMetadata.send(role)
        else
          raise ArgumentError, "#{role.inspect} is not a legacy role."
        end
      end

    end
  end
end
