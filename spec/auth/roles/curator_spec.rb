module Ddr::Auth::Roles
  RSpec.describe Curator do

    it_behaves_like "a role" do
      let(:role_type) { :curator }
      let(:type) { Ddr::Vocab::Roles.Curator }
      let(:permissions) { [:read, :download, :add_children, :edit, :replace, :arrange, :grant] }
    end
    
  end
end
