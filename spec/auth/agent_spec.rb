module Ddr::Auth
  RSpec.describe Agent do
    
    describe ".build" do
      subject { Agent.build(obj) }
      describe "when passed a String" do
        let(:obj) { "bob" }
        it "should return a new agent having the String as name" do
          expect(subject).to be_a(Agent)
          expect(subject.name.first).to eq("bob")
        end        
      end
      describe "when passed a User" do
        let(:obj) { FactoryGirl.build(:user) }
        it "should return a new agent having the user's string representation as name" do
          expect(subject).to be_a(Agent)
          expect(subject.name.first).to eq(obj.to_s)
        end              
      end
      describe "when passed a Group" do
        let(:obj) { Group.build("Editors") }
        it "should return a new agent having the group's string representation as name" do
          expect(subject).to be_a(Agent)
          expect(subject.name.first).to eq("Editors")
        end              
      end
    end

    describe "isomorphism" do
      it "agents should be equal if they have the same name" do
        expect(Agent.build("bob")).to eq(Agent.build("bob"))
        expect(Agent.build("bob")).not_to eq(Agent.build("sue"))
      end
    end

    describe "#to_s" do
      subject { Agent.new.tap { |a| a.name = "bob" } }
      it "should return the agent name" do
        expect(subject.to_s).to eq("bob")
      end
    end

  end
end
