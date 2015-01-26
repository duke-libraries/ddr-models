require "devise/omniauth_callbacks_controller"

class Users::OmniauthCallbacksController < Devise::OmniauthCallbacksController
  
  # Shibboleth callback
  def shibboleth
    @user = resource_class.from_omniauth(request.env["omniauth.auth"])
    sign_in_and_redirect @user
  end

end
