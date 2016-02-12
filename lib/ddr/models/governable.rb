module Ddr
  module Models
    module Governable
      extend ActiveSupport::Concern

      included do
        belongs_to :admin_policy,
                   predicate: ActiveFedora::RDF::ProjectHydra.isGovernedBy,
                   class_name: "Collection"
      end

      def copy_admin_policy_from(other)
        if admin_policy = other.admin_policy
          self.admin_policy = admin_policy
          logger.debug "Copied admin policy from #{other.model_and_id} to #{model_and_id}"
        end
      end

    end
  end
end
