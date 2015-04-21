module Ddr
  module Auth
    #
    # Hydra controller mixin for role-based access control
    #
    # Overrides Hydra::AccessControlsEnforcement#gated_discovery_filters
    # to apply role filters instead of permissions filters.
    #
    module RoleBasedAccessControlsEnforcement

      # List of PIDs for policies on which any of the current user's principals has a policy role
      def role_policies
        filters = current_user.agents.map { |agent| "#{Ddr::IndexFields::POLICY_ROLE}:\"#{agent}\"" }.join(" OR ")
        query = "#{Ddr::IndexFields::ACTIVE_FEDORA_MODEL}:Collection AND (#{filters})"
        results = ActiveFedora::SolrService.query(query, rows: Collection.count, fl: "id")
        results.map { |r| r["id"] }
      end

      def policy_role_filters
        rels = role_policies.map { |pid| [:is_governed_by, pid] }
        ActiveFedora::SolrService.construct_query_for_rel(rels, "OR")
      end

      def resource_role_filters
        current_user.agents.map { |agent| "#{Ddr::IndexFields::RESOURCE_ROLE}:\"#{agent}\"" }.join(" OR ")
      end

      def gated_discovery_filters
        [resource_role_filters, policy_role_filters]
      end      

    end
  end
end
