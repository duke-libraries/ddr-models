require 'spec_helper'

module Ddr
  module Auth
    RSpec.describe User, type: :model do

      subject { FactoryGirl.build(:user) }

      describe "context" do
        let(:env) do
          { "affiliation"=>"staff@duke.edu;student@duke.edu",
            "ismemberof"=>"group1;group2;group3"
          }
        end
        before { subject.context = env }
        its(:affiliations) { should contain_exactly(Affiliation::STAFF, Affiliation::STUDENT) }
      end

      describe "delegation to ability" do
        it "should delegate `can`" do
          expect(subject.ability).to receive(:can).with(:edit, "foo")
          subject.can :edit, "foo"
        end
        it "should delegate `cannot`" do
          expect(subject.ability).to receive(:cannot).with(:edit, "foo")
          subject.cannot :edit, "foo"
        end
        it "should delegate `can?`" do
          expect(subject.ability).to receive(:can?).with(:edit, "foo")
          subject.can? :edit, "foo"
        end
        it "should delegate `cannot?`" do
          expect(subject.ability).to receive(:cannot?).with(:edit, "foo")
          subject.cannot? :edit, "foo"
        end
      end

      describe "#member_of?" do
        before do
          allow(subject).to receive(:groups) { [ Group.new("foo"), Group.new("bar") ] }
        end
        it "should return true if the user is a member of the group" do
          expect(subject).to be_member_of("foo")
          expect(subject).to be_member_of(Group.new("foo"))
        end
        it "should return false if the user is not a member of the group" do
          expect(subject).not_to be_member_of("baz")
          expect(subject).not_to be_member_of(Group.new("baz"))
        end
      end

      describe "#authorized_to_act_as_superuser?" do
        it "should return false if the superuser group is not defined (nil)" do
          allow(Ddr::Auth).to receive(:superuser_group) { nil }
          expect(subject).not_to be_authorized_to_act_as_superuser
        end
        it "should return false if the user is not a member of the superuser group" do
          allow(subject).to receive(:groups) { [ Group.new("normal") ] }
          expect(subject).not_to be_authorized_to_act_as_superuser
        end
        it "should return true if the user is a member of the superuser group" do
          allow(subject).to receive(:groups) { [ Groups::SUPERUSERS ] }
          expect(subject).to be_authorized_to_act_as_superuser
        end
      end

      describe "#principal_name" do
        it "should return the principal name for the user" do
          expect(subject.principal_name).to eq(subject.user_key)
        end
      end

      describe "#agents" do
        it "should be a array of the user's groups and the user's person agent" do
          allow(subject).to receive(:groups) { [ Group.new("foo"), Group.new("bar") ] }
          expect(subject.agents).to contain_exactly("foo", "bar", subject.agent)
        end
      end

      describe "#to_agent" do
        it "should return the agent representation of the user" do
          expect(subject.to_agent).to eq(subject.principal_name)
        end
        describe "aliases" do
          its(:agent) { is_expected.to eq(subject.to_agent) }
        end
      end

      describe "#to_s" do
        it "should return the user's principal name (user_key)" do
          expect(subject.to_s).to eq(subject.principal_name)
          expect(subject.to_s).to eq(subject.eppn)
          expect(subject.to_s).to eq(subject.name)
          expect(subject.to_s).to eq(subject.user_key)
        end
      end

    end
  end
end
