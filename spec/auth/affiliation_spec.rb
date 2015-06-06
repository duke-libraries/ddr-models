module Ddr::Auth
  RSpec.describe Affiliation do

    describe "class methods" do
      describe ".all" do
        subject { described_class.all }
        it { is_expected.to eq([described_class::FACULTY, described_class::STAFF, described_class::STUDENT, described_class::EMERITUS, described_class::AFFILIATE, described_class::ALUMNI]) }
      end
      describe ".get" do
        subject { described_class.get(value) }
        describe "with a valid value" do
          let(:value) { "faculty" }
          it { should eq(described_class::FACULTY) }
        end
        describe "with an invalid value" do
          let(:value) { "foo" }
          it { should be_nil }
        end        
      end
      describe ".group" do
        subject { described_class.group(value) }
        describe "with a valid value" do
          let(:value) { "faculty" }
          it { should eq(described_class::FACULTY.group) }
        end
        describe "with an invalid value" do
          let(:value) { "foo" }
          it { should be_nil }
        end
      end
      describe ".groups" do
        subject { described_class.groups }
        it { is_expected.to eq([described_class::FACULTY.group, described_class::STAFF.group, described_class::STUDENT.group, described_class::EMERITUS.group, described_class::AFFILIATE.group, described_class::ALUMNI.group]) }
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
          it "should have the label \"Duke #{name.capitalize}\"" do
            expect(subject.group.label).to eq("Duke #{name.capitalize}")
          end
        end
      end
      describe "FACULTY" do
        subject { described_class::FACULTY }
        it_behaves_like "an affiliation constant", "faculty"
      end
      describe "STAFF" do
        subject { described_class::STAFF }
        it_behaves_like "an affiliation constant", "staff"
      end
      describe "STUDENT" do
        subject { described_class::STUDENT }
        it_behaves_like "an affiliation constant", "student"
      end
      describe "AFFILIATE" do
        subject { described_class::AFFILIATE }
        it_behaves_like "an affiliation constant", "affiliate"
      end
      describe "EMERITUS" do
        subject { described_class::EMERITUS }
        it_behaves_like "an affiliation constant", "emeritus"
      end
      describe "ALUMNI" do
        subject { described_class::ALUMNI }
        it_behaves_like "an affiliation constant", "alumni"
      end
    end

    describe "instance methods" do
      describe "#group" do
        subject { described_class::FACULTY }
        it "should return the group for the affiliation" do
          expect(subject.group).to be_a(Group)
        end
      end
    end

  end
end
