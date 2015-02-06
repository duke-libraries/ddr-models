RSpec.describe ApplicationController, type: :controller do
  controller do
    before_action :authenticate_user!
    def index; end
  end
  describe "authentication failure handling" do
    describe "when shibboleth user authentication is required" do
      before { allow(Ddr::Auth).to receive(:require_shib_user_authn) { true } }
      it "should redirect to the shib authn path" do
        get :index
        expect(response).to redirect_to(user_omniauth_authorize_path(:shibboleth))
      end
    end
    describe "when shibboleth user authentication is not required" do
      before { allow(Ddr::Auth).to receive(:require_shib_user_authn) { false } }
      it "should redirect to the new user session path" do
        get :index
        expect(response).to redirect_to(new_user_session_path)
      end
    end
  end
end
