module Ddr::Auth
  RSpec.describe WebAuthContext do

    subject { described_class.new(user, env) }

    let(:mock_ip_middleware) { double(calculate_ip: "8.8.8.8") }

    let(:env) do
      { "affiliation"=>"staff@duke.edu;student@duke.edu",
        "ismemberof"=>"group1;group2;group3",
        "action_dispatch.remote_ip"=>mock_ip_middleware
      }
    end

    shared_examples "a web auth context" do
      it_behaves_like "an auth context"
      its(:ip_address) { should eq("8.8.8.8") }
    end

    describe "authenticated" do
      let(:user) { FactoryGirl.build(:user) }

      it_behaves_like "a web auth context"
      its(:affiliation) { should contain_exactly("staff", "student") }
      its(:ismemberof) { should contain_exactly("group1", "group2", "group3") }

      describe "when env vars are not present" do
        let(:env) { {} }
        its(:affiliation) { should be_empty }
        its(:ismemberof) { should be_empty }
        its(:ip_address) { should be_nil }
      end
    end

    describe "anonymous" do
      let(:user) { nil }

      it_behaves_like "a web auth context"
      its(:affiliation) { should be_empty }
      its(:ismemberof) { should be_empty }

      describe "when env vars are not present" do
        let(:env) { {} }
        its(:ip_address) { should be_nil }
      end
    end

  end
end
