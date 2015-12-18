module Ddr::Index
  RSpec.describe Filter do

    its(:clauses) { are_expected.to eq [] }

    describe "equality" do
      describe "when the other is a Filter instance" do
        describe "and the clauses are equal" do
          subject { described_class.new(clauses: ["foo:bar", "spam:eggs"]) }
          let(:other) { described_class.new(clauses: ["foo:bar", "spam:eggs"]) }
          specify { expect(subject).to eq other }
        end
        describe "and the clauses are not equal" do
          subject { described_class.new(clauses: ["foo:bar", "bam:baz"]) }
          let(:other) { described_class.new(clauses: ["foo:bar", "spam:eggs"]) }
          specify { expect(subject).not_to eq other }
        end
      end
      describe "when the other is not a Filter instance" do
        subject { described_class.new(clauses: ["foo:bar", "spam:eggs"]) }
        let(:other) { double(clauses: ["foo:bar", "spam:eggs"]) }
        specify { expect(subject).not_to eq other }
      end
    end

    describe "class methods" do
      describe ".is_governed_by" do
        describe "with an object" do
          subject { described_class.is_governed_by(Item.new(pid: "test:1")) }
          its(:clauses) {
            are_expected.to eq([QueryClause.term(:is_governed_by, "info:fedora/test:1")])
          }
        end
        describe "with an ID" do
          subject { described_class.is_governed_by("test:1") }
          its(:clauses) {
            are_expected.to eq([QueryClause.term(:is_governed_by, "info:fedora/test:1")])
          }
        end
      end
      describe ".is_member_of_collection" do
        describe "with an object" do
          subject { described_class.is_member_of_collection(Item.new(pid: "test:1")) }
          its(:clauses) {
            are_expected.to eq([QueryClause.term(:is_member_of_collection, "info:fedora/test:1")])
          }
        end
        describe "with an ID" do
          subject { described_class.is_member_of_collection("test:1") }
          its(:clauses) {
            are_expected.to eq([QueryClause.term(:is_member_of_collection, "info:fedora/test:1")])
          }
        end
      end
      describe ".has_content" do
        subject { described_class.has_content }
        its(:clauses) { are_expected.to eq([QueryClause.where(:active_fedora_model, ["Component", "Attachment", "Target"])]) }
      end
      describe ".where" do
        subject { described_class.where("foo"=>"bar", "spam"=>"eggs", "stuff"=>["dog", "cat", "bird"]) }
        its(:clauses) {
          are_expected.to eq([QueryClause.where("foo", "bar"),
                              QueryClause.where("spam", "eggs"),
                              QueryClause.where("stuff", ["dog", "cat", "bird"])
                             ])
        }
      end
      describe ".raw" do
        subject { described_class.raw("foo:bar", "spam:eggs") }
        its(:clauses) { are_expected.to eq(["foo:bar", "spam:eggs"]) }
      end
      describe ".negative" do
        subject { described_class.negative("foo", "bar") }
        its(:clauses) { are_expected.to eq([QueryClause.negative("foo", "bar")]) }
      end
      describe ".present" do
        subject { described_class.present("foo") }
        its(:clauses) { are_expected.to eq([QueryClause.present("foo")]) }
      end
      describe ".absent" do
        subject { described_class.absent("foo") }
        its(:clauses) { are_expected.to eq([QueryClause.absent("foo")]) }
      end
      describe ".before_days" do
        subject { described_class.before_days("foo", 60) }
        its(:clauses) { are_expected.to eq([QueryClause.before_days("foo", 60)]) }
      end
      describe ".before" do
        subject { described_class.before("foo", DateTime.parse("Thu, 27 Aug 2015 17:42:34 -0400")) }
        its(:clauses) {
          are_expected.to eq([QueryClause.before("foo", DateTime.parse("Thu, 27 Aug 2015 17:42:34 -0400"))])
        }
      end
    end

    describe "API methods" do
      describe "#where" do
        it "adds raw query filters for the hash of conditions" do
          subject.where("foo"=>"bar", "spam"=>"eggs", "stuff"=>["dog", "cat", "bird"])
          expect(subject.clauses).to eq([QueryClause.where("foo", "bar"),
                                         QueryClause.where("spam", "eggs"),
                                         QueryClause.where("stuff", ["dog", "cat", "bird"])
                                        ])
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
          expect(subject.clauses).to eq([QueryClause.negative("foo", "bar")])
        end
      end
      describe "#present" do
        it "adds a \"field present\" query clause" do
          subject.present("foo")
          expect(subject.clauses).to eq([QueryClause.present("foo")])
        end
      end
      describe "#absent" do
        it "adds a \"field not present\" query clause" do
          subject.absent("foo")
          expect(subject.clauses).to eq([QueryClause.absent("foo")])
        end
      end
      describe "#before_days" do
        it "adds a date range query clause" do
          subject.before_days("foo", 60)
          expect(subject.clauses).to eq([QueryClause.before_days("foo", 60)])
        end
      end
      describe "#before" do
        it "adds a date range query clause" do
          subject.before("foo", DateTime.parse("Thu, 27 Aug 2015 17:42:34 -0400"))
          expect(subject.clauses).to eq([QueryClause.before("foo", DateTime.parse("Thu, 27 Aug 2015 17:42:34 -0400"))])
        end
      end
    end

  end
end
