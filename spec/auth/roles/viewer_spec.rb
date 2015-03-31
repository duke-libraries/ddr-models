module Ddr::Auth::Roles
  RSpec.describe Viewer do

    it { is_expected.to be_a(Role) }
    its(:role_type) { is_expected.to eq(:viewer) }
    
    describe "RDF type" do
      subject { described_class.type }
      it { is_expected.to eq(Ddr::Vocab::Roles.Viewer) }
    end    

  end
end
