module Ddr::Auth
  RSpec.describe User, type: :model do
    subject { FactoryGirl.build(:user) }
    its(:to_s) { should eq(subject.user_key) }
  end
end
