module Ddr
  module Models
    module HasPreservationMetadata
      extend ActiveSupport::Concern

      included do
        has_metadata "preservationMetadata",
                     type: Ddr::Datastreams::PreservationMetadataDatastream,
                     versionable: true,
                     control_group: "M"

        has_attributes :permanent_id, :permanent_url,
        datastream: "preservationMetadata", multiple: false

        after_create :assign_permanent_id!, if: "Ddr::Models.auto_assign_permanent_ids"
      end

      def permanent_id_manager
        @permanent_id_manager ||= Ddr::Managers::PermanentIdManager.new(self)
      end

      def assign_permanent_id!
        permanent_id_manager.assign_later
      end

    end
  end
end
