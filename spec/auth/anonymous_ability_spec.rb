module Ddr::Auth
  RSpec.describe AnonymousAbility do

    subject { described_class.new(auth_context) }
    let(:auth_context) { FactoryGirl.build(:auth_context, :anonymous) }

    its(:ability_definitions) { should eq(Ability.ability_definitions) }

  end
end
