module Ddr
  module Auth
    class FailureApp < Devise::FailureApp

      def respond
        if scope == :user && Ddr::Auth.require_shib_user_authn
          store_location!
          redirect_to user_omniauth_authorize_path(:shibboleth)
        else
          super
        end
      end

    end
  end
end
