module Ddr::Auth::Roles
  RSpec.describe MetadataEditor do

    it { is_expected.to be_a(Role) }
    its(:role_type) { is_expected.to eq(:metadata_editor) }
    
    describe "RDF type" do
      subject { described_class.type }
      it { is_expected.to eq(Ddr::Vocab::Roles.MetadataEditor) }
    end    

  end
end
