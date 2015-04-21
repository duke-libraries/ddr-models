module Ddr
  module Models
    module HasAdminMetadata
      extend ActiveSupport::Concern

      included do        
        has_metadata "adminMetadata",
          type: Ddr::Datastreams::AdministrativeMetadataDatastream,
          versionable: true,
          control_group: "M"

        has_attributes :local_id, :permanent_id, :permanent_url, :workflow_state,
          datastream: "adminMetadata", 
          multiple: false

        delegate :role_based_permissions, to: :roles
        delegate :publish, :publish!, :unpublish, :unpublish!, :published?, to: :workflow

        after_create :assign_permanent_id!, if: "Ddr::Models.auto_assign_permanent_ids"
      end

      include Ddr::Auth::LegacyRoles

      def permanent_id_manager
        @permanent_id_manager ||= Ddr::Managers::PermanentIdManager.new(self)
      end

      def roles
        @roles ||= Ddr::Managers::RoleManager.new(self)
      end

      def workflow
        @workflow ||= Ddr::Managers::WorkflowManager.new(self)
      end

      def assign_permanent_id!
        permanent_id_manager.assign_later
      end

      private

      def legacy_permissions
        Ddr::Auth::LegacyPermissions.new(permissions)
      end

      def set_resource_roles_from_legacy_data
        roles.revoke_resource_roles
        roles.grant *(legacy_permissions.to_resource_roles)
        roles.grant *legacy_downloader_to_resource_roles
      end

    end
  end
end
