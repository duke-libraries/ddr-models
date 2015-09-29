module Ddr::Index
  RSpec.describe Query do

    subject do
      QueryBuilder.build do |query|
        query
          .q("foo:bar")
          .where("spam"=>"eggs")
          .fields("id", "foo", "spam")
          .limit(50)
      end
    end

    its(:to_s) { is_expected.to eq("q=foo%3Abar&fq=%7B%21term+f%3Dspam%7Deggs&fl=id%2Cfoo%2Cspam&rows=50") }

    its(:params) { is_expected.to eq({q: "foo:bar", fl: "id,foo,spam", fq: ["{!term f=spam}eggs"], rows: 50}) }

  end
end
