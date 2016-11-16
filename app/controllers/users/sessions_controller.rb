class Users::SessionsController < Devise::SessionsController

  def new
    store_location_for(:user, request.referrer)
    if Ddr::Auth.require_shib_user_authn
      flash.discard(:alert)
      redirect_to user_omniauth_authorize_path(:shibboleth)
    else
      super
    end
  end

end
