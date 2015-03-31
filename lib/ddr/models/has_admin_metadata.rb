module Ddr
  module Models
    module HasAdminMetadata
      extend ActiveSupport::Concern

      included do
        has_metadata "adminMetadata",
                     type: Ddr::Datastreams::AdministrativeMetadataDatastream,
                     versionable: true,
                     control_group: "M"

        has_attributes :permanent_id, :permanent_url, :workflow_state,
                       datastream: "adminMetadata", multiple: false

        delegate :role_based_permissions, :principal_has_role?, to: :roles
        delegate :publish, :publish!, :unpublish, :unpublish!, :published?, to: :workflow

        before_save :set_resource_roles, if: :permissions_changed?
        after_create :assign_permanent_id!, if: "Ddr::Models.auto_assign_permanent_ids"
      end

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

      # Set resource roles based on permissions
      def set_resource_roles
        roles.revoke_resource_roles
        roles.grant *permissions_to_resource_roles        
      end

      private

      def permissions_to_resource_roles
        Ddr::Auth::HydraPermissions.new(permissions).to_resource_roles
      end

      def permissions_changed?
        # XXX This is not strictly accurate, but close enough
        rightsMetadata.changed?
      end

    end
  end
end
