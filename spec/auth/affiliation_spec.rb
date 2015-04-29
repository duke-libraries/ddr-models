module Ddr::Auth
  RSpec.describe Affiliation do

    describe "class methods" do
      describe ".all" do
        subject { described_class.all }
        it { is_expected.to eq([described_class::Faculty, described_class::Staff, described_class::Student, described_class::Emeritus, described_class::Affiliate, described_class::Alumni]) }
      end
      describe ".get" do
        subject { described_class.get("faculty") }
        it { is_expected.to eq(described_class::Faculty) }
      end
      describe ".group" do
        subject { described_class.group("faculty") }
        it { is_expected.to eq(described_class::Faculty.group) }
      end
      describe ".groups" do
        subject { described_class.groups }
        it { is_expected.to eq([described_class::Faculty.group, described_class::Staff.group, described_class::Student.group, described_class::Emeritus.group, described_class::Affiliate.group, described_class::Alumni.group]) }
      end
    end

    describe "constants" do
      shared_examples "an affiliation constant" do |name|
        it { is_expected.to eq(described_class.get(name)) }
        it { is_expected.to eq(name) }
        it { is_expected.to be_frozen }
        describe "group" do
          it "should be named \"duke.#{name}\"" do
            expect(subject.group).to eq("duke.#{name}")
          end
          it "should have a label" do
            expect(subject.group.label).to eq("Duke #{name.capitalize}")
          end
        end
      end
      describe "Faculty" do
        subject { described_class::Faculty }
        it_behaves_like "an affiliation constant", "faculty"
      end
      describe "Staff" do
        subject { described_class::Staff }
        it_behaves_like "an affiliation constant", "staff"
      end
      describe "Student" do
        subject { described_class::Student }
        it_behaves_like "an affiliation constant", "student"
      end
      describe "Affiliate" do
        subject { described_class::Affiliate }
        it_behaves_like "an affiliation constant", "affiliate"
      end
      describe "Emeritus" do
        subject { described_class::Emeritus }
        it_behaves_like "an affiliation constant", "emeritus"
      end
      describe "Alumni" do
        subject { described_class::Alumni }
        it_behaves_like "an affiliation constant", "alumni"
      end
    end

    describe "instance methods" do
      describe "#group" do
        subject { described_class::Faculty }
        it "should return the group for the affiliation" do
          expect(subject.group).to eq(Group.new("duke.faculty"))
        end
      end
    end

  end
end
