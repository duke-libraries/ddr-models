module Ddr::Auth
  RSpec.describe AbilityFactory do

    describe ".call" do
      subject { described_class.call(user, env) }

      describe "anonymous context" do
        let(:user) { nil }
        let(:env) { Hash.new }
        it { is_expected.to be_a(AnonymousAbility) }
      end

      describe "superuser context" do
        let(:user) { FactoryGirl.create(:user) }
        let(:env) { Hash.new }
        before {
          allow_any_instance_of(AuthContext).to receive(:superuser?) { true }
        }
        it { is_expected.to be_a(SuperuserAbility) }
      end
    end

  end
end
