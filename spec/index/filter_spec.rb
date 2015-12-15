module Ddr::Index
  RSpec.describe Filter do

    its(:clauses) { are_expected.to eq [] }

    describe "equality" do
      describe "when the other is a Filter instance" do
        describe "and the clauses are equal" do
          subject { described_class.new(["foo:bar", "spam:eggs"]) }
          let(:other) { described_class.new(["foo:bar", "spam:eggs"]) }
          specify { expect(subject).to eq other }
        end
        describe "and the clauses are not equal" do
          subject { described_class.new(["foo:bar", "bam:baz"]) }
          let(:other) { described_class.new(["foo:bar", "spam:eggs"]) }
          specify { expect(subject).not_to eq other }
        end
      end
      describe "when the other is not a Filter instance" do
        subject { described_class.new(["foo:bar", "spam:eggs"]) }
        let(:other) { double(clauses: ["foo:bar", "spam:eggs"]) }
        specify { expect(subject).not_to eq other }
      end
    end

    describe "class methods" do
      describe ".where" do
        subject { Filter.where("foo"=>"bar", "spam"=>"eggs", "stuff"=>["dog", "cat", "bird"]) }
        its(:clauses) { are_expected.to eq (["{!term f=foo}bar", "{!term f=spam}eggs", "stuff:(dog OR cat OR bird)"]) }
      end
      describe "#raw" do
        subject { Filter.raw("foo:bar", "spam:eggs") }
        its(:clauses) { are_expected.to eq(["foo:bar", "spam:eggs"]) }
      end
      describe "#negative" do
        subject { Filter.negative("foo", "bar") }
        its(:clauses) { are_expected.to eq(["-foo:bar"]) }
      end
      describe "#present" do
        subject { Filter.present("foo") }
        its(:clauses) { are_expected.to eq(["foo:[* TO *]"]) }
      end
      describe "#absent" do
        subject { Filter.absent("foo") }
        its(:clauses) { are_expected.to eq(["-foo:[* TO *]"]) }
      end
      describe "#before_days" do
        subject { Filter.before_days("foo", 60) }
        its(:clauses) { are_expected.to eq(["foo:[* TO NOW-60DAYS]"]) }
      end
      describe "#before" do
        subject { Filter.before("foo", DateTime.parse("Thu, 27 Aug 2015 17:42:34 -0400")) }
        its(:clauses) { are_expected.to eq(["foo:[* TO 2015-08-27T21:42:34Z]"]) }
      end
    end

    describe "instance methods" do
      describe "#where" do
        it "adds raw query filters for the hash of conditions" do
          subject.where("foo"=>"bar", "spam"=>"eggs", "stuff"=>["dog", "cat", "bird"])
          expect(subject.clauses).to eq(["{!term f=foo}bar", "{!term f=spam}eggs", "stuff:(dog OR cat OR bird)"])
        end
      end
      describe "#raw" do
        it "adds the query clauses w/o escaping" do
          subject.raw("foo:bar", "spam:eggs")
          expect(subject.clauses).to eq(["foo:bar", "spam:eggs"])
        end
      end
      describe "#negative" do
        it "adds a negation query clause" do
          subject.negative("foo", "bar")
          expect(subject.clauses).to eq(["-foo:bar"])
        end
      end
      describe "#present" do
        it "adds a \"field present\" query clause" do
          subject.present("foo")
          expect(subject.clauses).to eq(["foo:[* TO *]"])
        end
      end
      describe "#absent" do
        it "adds a \"field not present\" query clause" do
          subject.absent("foo")
          expect(subject.clauses).to eq(["-foo:[* TO *]"])
        end
      end
      describe "#before_days" do
        it "adds a date range query clause" do
          subject.before_days("foo", 60)
          expect(subject.clauses).to eq(["foo:[* TO NOW-60DAYS]"])
        end
      end
      describe "#before" do
        it "adds a date range query clause" do
          subject.before("foo", DateTime.parse("Thu, 27 Aug 2015 17:42:34 -0400"))
          expect(subject.clauses).to eq(["foo:[* TO 2015-08-27T21:42:34Z]"])
        end
      end
    end

  end
end
