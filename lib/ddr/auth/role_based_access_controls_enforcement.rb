module Ddr::Auth
  #
  # Controller mixin for role-based access control
  #
  module RoleBasedAccessControlsEnforcement

    def self.included(controller)
      controller.helper_method :authorized_to_act_as_superuser?
    end

    def current_ability
      @current_ability ||= AbilityFactory.call(current_user, request.env)
    end

    def authorized_to_act_as_superuser?
      current_ability.authorized_to_act_as_superuser?
    end

  end
end
