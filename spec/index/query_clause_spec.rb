module Ddr::Index
  RSpec.describe QueryClause do

    describe "class methods" do
      describe ".build" do
        subject { QueryClause.build("foo", "bar") }
        it { is_expected.to eq "foo:bar" }
      end
      describe ".unique_key" do
        subject { QueryClause.unique_key("test:1") }
        it { is_expected.to eq "{!term f=id}test:1" }
      end
      describe ".id" do
        subject { QueryClause.id("test:1") }
        it { is_expected.to eq "{!term f=id}test:1" }
      end
      describe ".negative" do
        subject { QueryClause.negative("foo", "bar") }
        it { is_expected.to eq "-foo:bar" }
      end
      describe ".present" do
        subject { QueryClause.present("foo") }
        it { is_expected.to eq "foo:[* TO *]" }
      end
      describe ".absent" do
        subject { QueryClause.absent("foo") }
        it { is_expected.to eq "-foo:[* TO *]" }
      end
      describe ".or_values" do
        subject { QueryClause.or_values("foo", ["bar", "baz"]) }
        it { is_expected.to eq "foo:(bar OR baz)" }
      end
      describe ".before" do

      end
      describe ".before_days" do
        subject { QueryClause.before_days("foo", 5) }
        it { is_expected.to eq "foo:[* TO NOW-5DAYS]" }
      end
      describe ".term" do

      end
    end

  end
end
