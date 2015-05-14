module Ddr
  module Models
    module AccessControllable
      extend ActiveSupport::Concern

      included do
        include Hydra::AccessControls::Permissions
      end

      def set_initial_permissions(user_creator = nil)
        warn "[DEPRECATION] `set_initial_permissions` is deprecated" \
             " and should not be used with role-based access control" \
             " (#{caller.first})."
        if user_creator
          self.permissions_attributes = [{type: "user", access: "edit", name: user_creator.to_s}]
        end
      end

      def copy_permissions_from(other)
        # XXX active-fedora < 7.0
        warn "[DEPRECATION] `copy_permissions_from` is deprecated" \
             " and should not be used with role-based access control" \
             " (#{caller.first})."
        self.permissions_attributes = other.permissions.collect { |p| p.to_hash }
      end
    end
  end
end
