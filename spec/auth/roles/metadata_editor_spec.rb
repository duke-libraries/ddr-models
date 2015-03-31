module Ddr::Auth::Roles
  RSpec.describe MetadataEditor do

    it { is_expected.to be_a(Role) }
    its(:role_type) { is_expected.to eq(:metadata_editor) }
    its(:permissions) { is_expected.to match_array([:read, :download, :edit]) }
    
    describe "RDF type" do
      subject { described_class.type }
      it { is_expected.to eq(Ddr::Vocab::Roles.MetadataEditor) }
    end    

  end
end
