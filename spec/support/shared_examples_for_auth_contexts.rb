module Ddr::Auth
  RSpec.shared_examples "an auth context" do

    describe "#anonymous?" do
      describe "when a user is present" do
        before { allow(subject).to receive(:user) { double } }
        its(:anonymous?) { should be false }
      end
      describe "when no user is present" do
        before { allow(subject).to receive(:user) { nil } }
        its(:anonymous?) { should be true }
      end
    end

    describe "#authenticated?" do
      describe "when a user is present" do
        before { allow(subject).to receive(:user) { double } }
        its(:authenticated?) { should be true }
      end
      describe "when no user is present" do
        before { allow(subject).to receive(:user) { nil } }
        its(:authenticated?) { should be false }
      end
    end

    describe "#duke_agent?" do
      describe "when the auth context is anonymous" do
        before { allow(subject).to receive(:user) { nil } }
        its(:duke_agent?) { should be false }
      end
      describe "when the auth context agent is from Duke" do
        before { allow(subject).to receive(:user) { double(agent: "example@duke.edu") } }
        its(:duke_agent?) { should be true }
      end
      describe "when the auth context agent not is from Duke" do
        before { allow(subject).to receive(:user) { double(agent: "example@unc.edu") } }
        its(:duke_agent?) { should be false }
      end
    end

    describe "#agents" do
      before { allow(subject).to receive(:groups) { [ Groups::PUBLIC, Groups::REGISTERED, Group.new("foo") ] } }
      its(:agents) { should contain_exactly(subject.agent, Groups::PUBLIC.agent, Groups::REGISTERED.agent, "foo") }
    end

    describe "#member_of?" do
      before { allow(subject).to receive(:groups) { [ Groups::PUBLIC, Groups::REGISTERED, Group.new("foo") ] } }
      describe "when given a Group" do
        let(:group1) { Group.new("foo") }
        let(:group2) { Group.new("bar") }
        it "should test whether its groups includes the group" do
          expect(subject.member_of?(group1)).to be true
          expect(subject.member_of?(group2)).to be false
        end
      end
      describe "when given a String" do
        let(:group1) { "foo" }
        let(:group2) { "bar" }
        it "should test whether its groups includes a group with that id" do
          expect(subject.member_of?(group1)).to be true
          expect(subject.member_of?(group2)).to be false
        end
      end
    end

    describe "#authorized_to_act_as_superuser?" do
      describe "when a member of the superusers group" do
        before do
          allow(subject).to receive(:groups) { [ Groups::SUPERUSERS ] }
        end
        its(:authorized_to_act_as_superuser?) { should be true }
      end
      describe "when not a member of the superusers group" do
        before do
          allow(subject).to receive(:groups) { [ Groups::PUBLIC ] }
        end
        its(:authorized_to_act_as_superuser?) { should be false }
      end
    end

  end
end
