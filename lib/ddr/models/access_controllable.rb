module Ddr
  module Models
    module AccessControllable
      extend ActiveSupport::Concern
      extend Deprecation

      included do
        include Hydra::AccessControls::Permissions
      end

      def set_initial_permissions(user_creator = nil)
        if user_creator
          self.permissions_attributes = [{type: "user", access: "edit", name: user_creator.to_s}]
        end
      end
      deprecation_deprecate :set_initial_permissions

      def copy_permissions_from(other)
        self.permissions_attributes = other.permissions.collect { |p| p.to_hash }
      end
      deprecation_deprecate :copy_permissions_from
    end
  end
end
