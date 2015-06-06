module Ddr::Auth
  RSpec.describe Group do

    subject { described_class.new("admins", label: "Administrators") }

    its(:agent) { should eq("admins") }
    its(:label) { should eq("Administrators") }
    its(:id) { should eq("admins") }
    its(:to_s) { should eq("admins") }
    it { should be_frozen }

    describe "default label" do
      subject { described_class.new("admins") }
      its(:label) { should eq("admins") }
    end

    describe "equality" do
      it { should eq("admins") }
      it { should eq(described_class.new("admins")) }
      it { should_not eq(described_class.new("administrators", label: "Administrators")) }
    end

    describe "#has_member?" do
      let!(:user) { FactoryGirl.build(:user) }
      describe "when the group doesn't have a rule" do
        describe "and the group is in the user's groups" do
          before { allow(user).to receive(:groups) { [ subject ] } }
          it "should be true" do
            expect(subject.has_member?(user)).to be true
          end
        end
        describe "and the group is not in the user's groups" do
          before { allow(user).to receive(:groups) { [ ] } }
          it "should be false" do
            expect(subject.has_member?(user)).to be false
          end
        end
      end
      describe "when the group has a rule" do
        describe "and the user passes the rule" do
          subject do
            described_class.new("admins", label: "Administrators") do |user|
              true
            end
          end
          it "should be true" do
            expect(subject.has_member?(user)).to be true
          end
        end
        describe "and the user fails the rule" do
          subject do
            described_class.new("admins", label: "Administrators") do |user|
              false
            end
          end
          it "should be false" do
            expect(subject.has_member?(user)).to be false
          end
        end
      end
    end

  end
end
