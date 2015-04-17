module Ddr::Auth
  RSpec.describe Group do

    subject { described_class.new("admins") }

    its(:agent) { is_expected.to eq("admins") }

    describe "#has_member?" do
      let!(:user) { FactoryGirl.build(:user) }
      context "when the user's groups include the group" do
        before { allow(user).to receive(:groups) { Groups.new([subject]) } }
        it "should be true" do
          expect(subject.has_member?(user)).to be true
        end
      end
      context "when the user's groups do not include the group" do
        before { allow(user).to receive(:groups) { Groups.new([Group.new("foo")]) } }
        it "should be false" do
          expect(subject.has_member?(user)).to be false
        end
      end
    end

  end
end
