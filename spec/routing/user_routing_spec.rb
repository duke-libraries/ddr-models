RSpec.describe "users router", type: :routing do
  it "should have a new session route" do
    expect(get: '/users/sign_in').to route_to(controller: 'users/sessions', action: 'new')
  end
  it "should have a new session path helper" do
    expect(get: new_user_session_path).to route_to(controller: 'users/sessions', action: 'new')
  end
  it "should have a destroy session route" do
    expect(get: '/users/sign_out').to route_to(controller: 'users/sessions', action: 'destroy')
  end
  it "should have a destroy session path helper" do
    expect(get: destroy_user_session_path).to route_to(controller: 'users/sessions', action: 'destroy')
  end
  it "should have a shibboleth authentication path" do
    expect(get: '/users/auth/shibboleth').to route_to(controller: 'users/omniauth_callbacks', action: 'passthru', provider: 'shibboleth')
  end
  it "should have a shibboleth authentication path helper" do
    expect(get: user_omniauth_authorize_path(:shibboleth)).to route_to(controller: 'users/omniauth_callbacks', action: 'passthru', provider: 'shibboleth')
  end
  describe "redirects", type: :request do
    it "should have a signed out path" do
      get '/users/signed_out'
      expect(response).to redirect_to('/')
    end
  end
end
