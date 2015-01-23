Rails.application.routes.draw do
  devise_for :users, controllers: { omniauth_callbacks: "users/omniauth_callbacks", sessions: "users/sessions" }
  devise_scope :user do
    get "/users/signed_out", to: redirect("/"), as: "user_signed_out"
  end
end
