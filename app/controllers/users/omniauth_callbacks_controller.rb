require "devise/omniauth_callbacks_controller"

class Users::OmniauthCallbacksController < Devise::OmniauthCallbacksController
  
  def shibboleth
    user = resource_class.from_omniauth(request.env["omniauth.auth"])
    set_flash_message :notice, :success, kind: "Duke NetID"
    sign_in_and_redirect user
  end

  def after_sign_in_path_for(resource)
    request.env["omniauth.origin"] || super
  end

end
