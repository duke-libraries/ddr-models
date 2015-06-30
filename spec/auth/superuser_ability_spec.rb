require 'cancan/matchers'

module Ddr::Auth
  RSpec.describe SuperuserAbility do

    subject { described_class.new(auth_context) }
    
    let(:auth_context) { FactoryGirl.build(:auth_context) }

    it { should be_able_to(:manage, :all) }
    
  end
end
