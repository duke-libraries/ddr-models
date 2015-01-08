module Ddr
  module Models
    module HasAdminMetadata
      extend ActiveSupport::Concern

      included do
        has_metadata "adminMetadata",
                     type: Ddr::Datastreams::AdminMetadataDatastream,
                     versionable: true,
                     control_group: "M"

        has_attributes :permanent_id, :permanent_url, 
                       datastream: "adminMetadata", multiple: false

        delegate :principal_has_role?, to: :roles

        after_create :assign_permanent_id!, if: "Ddr::Models.auto_assign_permanent_ids"
      end

      def permanent_id_manager
        @permanent_id_manager ||= Ddr::Managers::PermanentIdManager.new(self)
      end

      def roles
        @roles || Ddr::Managers::RoleManager.new(self)
      end

      def assign_permanent_id!
        permanent_id_manager.assign_later
      end

    end
  end
end
