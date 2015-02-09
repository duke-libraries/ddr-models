RSpec.describe Users::SessionsController, type: :controller do

  before { request.env["devise.mapping"] = Devise.mappings[:user] }

  describe "#new" do
    before { request.env["HTTP_REFERER"] = "/foo/bar" }
    describe "when shibboleth user authentication is required" do
      before { allow(Ddr::Auth).to receive(:require_shib_user_authn) { true } }
      it "should redirect to the shib authn path, setting the origin to the previous page" do
        get :new
        expect(response).to redirect_to(user_omniauth_authorize_path(:shibboleth, origin: "/foo/bar"))
      end
    end

    describe "when shibboleth user authentication is NOT required" do
      before { allow(Ddr::Auth).to receive(:require_shib_user_authn) { false } }
      it "should store the location of the previous page and render the 'new' template" do
        expect(subject).to receive(:store_location_for).with(:user, "/foo/bar")
        get :new
        expect(response).to render_template(:new)
      end
    end
  end

end