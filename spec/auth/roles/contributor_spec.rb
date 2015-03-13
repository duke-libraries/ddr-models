module Ddr::Auth::Roles
  RSpec.describe Contributor do

    it { is_expected.to be_a(Role) }
    its(:role_type) { is_expected.to eq(:contributor) }
    
    describe "RDF type" do
      subject { described_class.type }
      it { is_expected.to eq(Ddr::Vocab::Roles.Contributor) }
    end    

  end
end
