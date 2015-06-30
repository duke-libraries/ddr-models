module Ddr
  module Auth
    #
    # Hydra controller mixin for role-based access control
    #
    # Overrides Hydra::AccessControlsEnforcement#gated_discovery_filters
    # to apply role filters instead of permissions filters.
    #
    module RoleBasedAccessControlsEnforcement

      def self.included(controller)
        controller.delegate :authorized_to_act_as_superuser?, to: :current_ability
        controller.helper_method :authorized_to_act_as_superuser?
      end

      def current_ability
        @current_ability ||= AbilityFactory.call(current_user, request.env)
      end

      # List of PIDs for policies on which any of the current user's agent has a role in policy scope
      def policy_role_policies
        @policy_role_policies ||= Array.new.tap do |pids|
          filters = current_ability.agents.map do |agent|
            "#{Ddr::IndexFields::POLICY_ROLE}:\"#{agent}\""
          end.join(" OR ")
          query = "#{Ddr::IndexFields::ACTIVE_FEDORA_MODEL}:Collection AND (#{filters})"
          results = ActiveFedora::SolrService.query(query, rows: Collection.count, fl: "id")
          results.each_with_object(pids) { |r, memo| memo << r["id"] }
        end
      end

      def policy_role_filters
        if policy_role_policies.present?
          rels = policy_role_policies.map { |pid| [:is_governed_by, pid] }
          ActiveFedora::SolrService.construct_query_for_rel(rels, "OR")
        end
      end

      def resource_role_filters
        current_ability.agents.map do |agent|
          ActiveFedora::SolrService.raw_query(Ddr::IndexFields::RESOURCE_ROLE, agent)
        end.join(" OR ")
      end

      def gated_discovery_filters
        [resource_role_filters, policy_role_filters].compact
      end

    end
  end
end
