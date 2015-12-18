module Ddr::Index
  RSpec.describe QueryClause do

    describe "class methods" do
      describe ".unique_key" do
        subject { described_class.unique_key("test:1") }
        its(:to_s) { is_expected.to eq "{!term f=id}test:1" }
      end
      describe ".id" do
        subject { described_class.id("test:1") }
        its(:to_s) { is_expected.to eq "{!term f=id}test:1" }
      end
      describe ".negative" do
        subject { described_class.negative("foo", "Jungle Fever") }
        its(:to_s) { is_expected.to eq "-foo:\"Jungle Fever\"" }
      end
      describe ".present" do
        subject { described_class.present("foo") }
        its(:to_s) { is_expected.to eq "foo:[* TO *]" }
      end
      describe ".absent" do
        subject { described_class.absent("foo") }
        its(:to_s) { is_expected.to eq "-foo:[* TO *]" }
      end
      describe ".disjunction" do
        subject { described_class.disjunction("foo", ["Jungle Fever", "bar"]) }
        its(:to_s) { is_expected.to eq "{!lucene q.op=OR df=foo}\"Jungle Fever\" bar" }
      end
      describe ".before" do
        subject { described_class.before("foo", DateTime.parse("2015-12-14T20:40:06Z")) }
        its(:to_s) { is_expected.to eq "foo:[* TO 2015-12-14T20:40:06Z]" }
      end
      describe ".before_days" do
        subject { described_class.before_days("foo", 5) }
        its(:to_s) { is_expected.to eq "foo:[* TO NOW-5DAYS]" }
      end
      describe ".term" do
        subject { described_class.term("foo", "bar") }
        its(:to_s) { is_expected.to eq "{!term f=foo}bar" }
      end
      describe ".where" do
        describe "when the value is a string" do
          subject { described_class.where("foo", "Jungle Fever") }
          its(:to_s) { is_expected.to eq "foo:\"Jungle Fever\"" }
        end
        describe "when the value is an Array with one entry" do
          subject { described_class.where("foo", ["Jungle Fever"]) }
          its(:to_s) { is_expected.to eq "foo:\"Jungle Fever\"" }
        end
        describe "when the value is an array with multiple entries" do
          subject { described_class.where("foo", ["Jungle Fever", "bar"]) }
          its(:to_s) { is_expected.to eq "{!lucene q.op=OR df=foo}\"Jungle Fever\" bar" }
        end
      end
    end

  end
end
