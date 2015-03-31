module Ddr::Auth::Roles
  RSpec.describe MetadataEditor do

    it_behaves_like "a role" do
      let(:role_type) { :metadata_editor }
      let(:type) { Ddr::Vocab::Roles.MetadataEditor }
      let(:permissions) { [:read, :download, :edit] }
    end
    
  end
end
