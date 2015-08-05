module Ddr::Auth
  RSpec.describe DetachedAuthContext do

    subject { described_class.new(user, nil) }

    let(:user) { FactoryGirl.build(:user) }

    it_behaves_like "an auth context"

    before do
      allow(subject).to receive(:ldap_result) do
        double(affiliation: ["staff", "student"], ismemberof: ["group1", "group2", "group3"])
      end
    end

    its(:affiliation) { should contain_exactly("staff", "student") }
    its(:ismemberof) { should contain_exactly("group1", "group2", "group3") }
    its(:ip_address) { should be_nil }

  end
end
