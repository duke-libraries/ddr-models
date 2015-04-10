module Ddr::Auth::Roles
  RSpec.describe Editor do

    it_behaves_like "a role" do
      let(:role_type) { :editor }
      let(:type) { Ddr::Vocab::Roles.Editor }
      let(:permissions) { [:read, :download, :add_children, :edit, :replace, :arrange] }
    end

  end
end
