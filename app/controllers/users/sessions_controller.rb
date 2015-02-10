class Users::SessionsController < Devise::SessionsController

  def new
    if Ddr::Auth.require_shib_user_authn
      redirect_to user_omniauth_authorize_path(:shibboleth, origin: request.referrer)
    else
      store_location_for(:user, request.referrer)
      super
    end
  end

  def after_sign_out_path_for(scope)
    return Ddr::Auth.sso_logout_url if Ddr::Auth.require_shib_user_authn
    super
  end

end
