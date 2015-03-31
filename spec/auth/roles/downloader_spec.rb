module Ddr::Auth::Roles
  RSpec.describe Downloader do

    it { is_expected.to be_a(Role) }
    its(:role_type) { is_expected.to eq(:downloader) }
    
    describe "RDF type" do
      subject { described_class.type }
      it { is_expected.to eq(Ddr::Vocab::Roles.Downloader) }
    end    

  end
end
