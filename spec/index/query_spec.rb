module Ddr::Index
  RSpec.describe Query do

    describe "initialized with attributes" do
      let(:id) { UniqueKeyField.instance }
      let(:foo) { Field.new("foo") }
      let(:spam) { Field.new("spam") }
      let(:filter) { Filter.where(spam=>"eggs") }
      let(:sort_order) { SortOrder.new(field: foo, order: "asc") }
      let(:fields) { [id, foo, spam] }

      subject {
        described_class.new(q: "foo:bar",
                            filters: [filter],
                            fields: fields,
                            sort: sort_order,
                            rows: 50)
      }

      its(:to_s) {
        is_expected.to eq "q=foo%3Abar&fq=spam%3Aeggs&fl=id%2Cfoo%2Cspam&sort=foo+asc&rows=50"
      }
      its(:params) {
        is_expected.to eq({q: "foo:bar", fl: "id,foo,spam", fq: ["spam:eggs"], sort: "foo asc", rows: 50})
      }
    end

    describe "initialized with a block" do
      subject {
        described_class.new do
          q "foo:bar"
          where "spam"=>"eggs"
          fields :id, "foo", "spam"
          asc "foo"
          limit 50
        end
      }

      its(:to_s) {
        is_expected.to eq "q=foo%3Abar&fq=spam%3Aeggs&fl=id%2Cfoo%2Cspam&sort=foo+asc&rows=50"
      }
      its(:params) {
        is_expected.to eq({q: "foo:bar", fl: "id,foo,spam", fq: ["spam:eggs"], sort: "foo asc", rows: 50})
      }
    end

  end
end
