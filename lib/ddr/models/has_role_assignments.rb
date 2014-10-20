module Ddr
  module Models
    module HasRoleAssignments
      extend ActiveSupport::Concern

      included do
        has_metadata name: "roleAssignments", 
                     type: Ddr::Datastreams::RoleAssignmentsDatastream,
                     versionable: true, 
                     control_group: "M"

        delegate :principal_has_role?, to: :roleAssignments
      end

    end
  end
end
