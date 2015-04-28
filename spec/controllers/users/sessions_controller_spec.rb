RSpec.describe Users::SessionsController, type: :controller do

  before { request.env["devise.mapping"] = Devise.mappings[:user] }

  describe "#new" do
    before { request.env["HTTP_REFERER"] = "/foo/bar" }
    it "should store the location of the previous page" do
      expect(subject).to receive(:store_location_for).with(:user, "/foo/bar")
      get :new
    end
    describe "when shibboleth user authentication is required" do
      before { allow(Ddr::Auth).to receive(:require_shib_user_authn) { true } }
      it "should redirect to the shib authn path" do
        get :new
        expect(response).to redirect_to(user_omniauth_authorize_path(:shibboleth))
      end
      it "should discard the flash alert" do
        expect_any_instance_of(ActionDispatch::Flash::FlashHash).to receive(:discard).with(:alert)
        get :new
      end
    end

    describe "when shibboleth user authentication is NOT required" do
      before { allow(Ddr::Auth).to receive(:require_shib_user_authn) { false } }
      it "should store the location of the previous page and render the 'new' template" do
        get :new
        expect(response).to render_template(:new)
      end
      it "should NOT discard the flash alert" do
        expect_any_instance_of(ActionDispatch::Flash::FlashHash).not_to receive(:discard).with(:alert)
        get :new
      end
    end
  end

end
