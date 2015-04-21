module Ddr::Auth
  RSpec.describe Affiliation do

    describe "class methods" do
      describe ".all" do
        subject { described_class.all }
        it { is_expected.to eq([described_class::Faculty, described_class::Staff, described_class::Student, described_class::Emeritus, described_class::Affiliate, described_class::Alumni]) }
      end
      describe ".get" do
        subject { described_class.get(:faculty) }
        it { is_expected.to eq(described_class::Faculty) }
      end
      describe ".group" do
        subject { described_class.group(:faculty) }
        it { is_expected.to eq(described_class::Faculty.group) }
      end
      describe ".groups" do
        subject { described_class.groups }
        it { is_expected.to eq([described_class::Faculty.group, described_class::Staff.group, described_class::Student.group, described_class::Emeritus.group, described_class::Affiliate.group, described_class::Alumni.group]) }
      end
    end

    describe "constants" do
      describe "Faculty" do
        subject { described_class::Faculty }
        it { is_expected.to eq(described_class.get(:faculty)) }
        it { is_expected.to eq(:faculty) }
      end
      describe "Staff" do
        subject { described_class::Staff }
        it { is_expected.to eq(described_class.get(:staff)) }
        it { is_expected.to eq(:staff) }
      end
      describe "Student" do
        subject { described_class::Student }
        it { is_expected.to eq(described_class.get(:student)) }
        it { is_expected.to eq(:student) }
      end
      describe "Affiliate" do
        subject { described_class::Affiliate }
        it { is_expected.to eq(described_class.get(:affiliate)) }
        it { is_expected.to eq(:affiliate) }
      end
      describe "Emeritus" do
        subject { described_class::Emeritus }
        it { is_expected.to eq(described_class.get(:emeritus)) }
        it { is_expected.to eq(:emeritus) }
      end
      describe "Alumni" do
        subject { described_class::Alumni }
        it { is_expected.to eq(described_class.get(:alumni)) }
        it { is_expected.to eq(:alumni) }
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
