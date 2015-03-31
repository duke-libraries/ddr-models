module Ddr::Auth::Roles
  RSpec.describe Viewer do

    it_behaves_like "a role" do
      let(:role_type) { :viewer }
      let(:type) { Ddr::Vocab::Roles.Viewer }
      let(:permissions) { [:read] }
    end

  end
end
