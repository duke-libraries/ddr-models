module Ddr::Auth
  RSpec.describe Group do

    subject { described_class.new("admins", label: "Administrators") }

    its(:agent) { is_expected.to eq("admins") }
    its(:label) { is_expected.to eq("Administrators") }
    its(:to_s) { is_expected.to eq("admins") }
    it { is_expected.to be_frozen }

    describe "default label" do
      subject { described_class.new("admins") }
      its(:label) { is_expected.to eq("admins") }
    end

    describe "equality" do
      it { is_expected.to eq(described_class.new("admins")) }
      it { is_expected.not_to eq(described_class.new("administrators", label: "Administrators")) }
    end

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
