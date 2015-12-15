module Ddr::Index
  RSpec.describe Query do
    let(:id) { UniqueKeyField.instance }
    let(:foo) { Field.new("foo") }
    let(:spam) { Field.new("spam") }
    let(:filter) { Filter.where(spam=>"eggs") }
    let(:sort_order) { SortOrder.new(field: foo, order: "asc") }
    let(:fields) { [id, foo, spam] }
    subject {
      described_class.new(q: "foo:bar",
                          filters: filter,
                          fields: fields,
                          sort: sort_order,
                          rows: 50)
    }
    its(:to_s) {
      is_expected.to eq "q=foo%3Abar&fq=%7B%21term+f%3Dspam%7Deggs&fl=id%2Cfoo%2Cspam&sort=foo+asc&rows=50"
    }
    its(:params) {
      is_expected.to eq({q: "foo:bar", fl: "id,foo,spam", fq: ["{!term f=spam}eggs"], sort: "foo asc", rows: 50})
    }
  end
end
