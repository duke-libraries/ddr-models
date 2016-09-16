module Ddr::Index
  RSpec.describe QueryBuilder do
    describe "DSL" do
      describe "id" do
        subject { described_class.new { id "test:1" } }
        specify {
          expect(subject.query.rows).to eq 1
          expect(subject.query.q).to eq QueryClause.id("test:1")
        }
      end
      describe "q" do
        subject { described_class.new { q "foo:bar" } }
        specify { expect(subject.query.q).to eq "foo:bar" }
      end
      describe "asc" do
        subject { described_class.new { asc "foo", "bar" } }
        specify {
          expect(subject.query.sort).to eq [SortOrder.asc("foo"), SortOrder.asc("bar")]
        }
      end
      describe "desc" do
        subject { described_class.new { desc "foo", "bar" } }
        specify {
          expect(subject.query.sort).to eq [SortOrder.desc("foo"), SortOrder.desc("bar")]
        }
      end
      describe "filter" do
        subject { described_class.new { filter Filter.where("foo"=>"bar") } }
        specify { expect(subject.query.filters).to eq [Filter.where("foo"=>"bar")] }
      end
      describe "filters" do
        subject {
          described_class.new { filters Filter.where("foo"=>"bar"), Filter.where("bing"=>"bang") }
        }
        specify {
          expect(subject.query.filters).to eq([Filter.where("foo"=>"bar"),
                                               Filter.where("bing"=>"bang")
                                              ])
        }
      end
      describe "field" do
        subject { described_class.new { field "foo", "bar" } }
        specify { expect(subject.query.fields).to include("foo", "bar") }
      end
      describe "fields" do
        subject { described_class.new { fields "foo", "bar" } }
        specify { expect(subject.query.fields).to include("foo", "bar") }
      end
      describe "sort" do
        subject { described_class.new { sort "foo"=>"asc", "bar"=>"desc" } }
        specify {
          expect(subject.query.sort).to eq([SortOrder.new(field: "foo", order: "asc"),
                                            SortOrder.new(field: "bar", order: "desc")
                                           ])
        }
      end
      describe "order_by" do
        subject { described_class.new { order_by "foo"=>"asc", "bar"=>"desc" } }
        specify { expect(subject.query.sort).to eq [SortOrder.new(field: "foo", order: "asc"), SortOrder.new(field: "bar", order: "desc")] }
      end
      describe "limit" do
        subject { described_class.new { limit 5 } }
        specify { expect(subject.query.rows).to eq 5 }
      end
      describe "rows" do
        subject { described_class.new { rows 5 } }
        specify { expect(subject.query.rows).to eq 5 }
      end
      describe "raw" do
        subject { described_class.new { raw "foo:bar" } }
        specify { expect(subject.query.filters).to eq [Filter.raw("foo:bar")] }
      end
      describe "where" do
        subject { described_class.new { where "foo"=>"bar" } }
        specify { expect(subject.query.filters).to eq [Filter.where("foo"=>"bar")] }
      end
      describe "absent" do
        subject { described_class.new { absent "foo" } }
        specify { expect(subject.query.filters).to eq [Filter.absent("foo")] }
      end
      describe "present" do
        subject { described_class.new { present "foo" } }
        specify { expect(subject.query.filters).to eq [Filter.present("foo")] }
      end
      describe "before" do
        subject {
          described_class.new { before "foo", DateTime.parse("2015-12-14T20:40:06Z") }
        }
        specify {
          expect(subject.query.filters).to eq [Filter.before("foo", DateTime.parse("2015-12-14T20:40:06Z"))]
        }
      end
      describe "before_days" do
        subject { described_class.new { before_days "foo", 7 } }
        specify { expect(subject.query.filters).to eq [Filter.before_days("foo", 7)] }
      end
      describe "join" do
        subject {
          described_class.new do
            join from: :id, to: :collection_uri, where: {admin_set: "dvs"}
          end
        }
        specify {
          expect(subject.query.filters).to eq [Filter.join(from: :id, to: :collection_uri, where: {admin_set: "dvs"})]
        }
      end
      describe "regexp" do
        subject { described_class.new { regexp "foo", "foo/bar.*" } }
        specify {
          expect(subject.query.filters).to eq [Filter.regexp("foo", "foo/bar.*")]
        }
      end
    end

    describe "using static filters" do
      describe "has_content" do
        before { subject.has_content }
        specify { expect(subject.query.filters).to eq [Filter.has_content] }
      end
      describe "is_governed_by" do
        before { subject.is_governed_by "test:1" }
        specify { expect(subject.query.filters).to eq [Filter.is_governed_by("test:1")] }
      end
      describe "is_governed_by" do
        before { subject.is_member_of_collection "test:1" }
        specify { expect(subject.query.filters).to eq [Filter.is_member_of_collection("test:1")] }
      end
    end

    describe "passing local vars" do
      let(:local_var) { double(bar: "bar") }
      subject {
        described_class.new(local_var) { |foo| asc foo.bar }
      }
      specify {
        expect(subject.query.sort).to eq [SortOrder.asc("bar")]
      }
    end
  end
end
