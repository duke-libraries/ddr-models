class Users::SessionsController < Devise::SessionsController

  def after_sign_out_path_for(scope)
    user_signed_out_path
  end

end
