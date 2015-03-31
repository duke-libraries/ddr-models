module Ddr::Auth::Roles
  RSpec.describe Contributor do

    it_behaves_like "a role" do
      let(:role_type) { :contributor }
      let(:type) { Ddr::Vocab::Roles.Contributor }
      let(:permissions) { [:read, :add_children] }
    end

  end
end
