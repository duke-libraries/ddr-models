module Ddr::Index
  RSpec.describe Filter do

    describe "#where(conditions)" do
      it "should add raw query filters for the field, value hash of conditions" do
        subject.where("foo"=>"bar", "spam"=>"eggs", "stuff"=>["dog", "cat", "bird"])
        expect(subject.clauses).to eq(["{!term f=foo}bar", "{!term f=spam}eggs", "stuff:(dog OR cat OR bird)"])
      end
    end

    describe "#raw(*clauses)" do
      it "should add the clauses w/o escaping" do
        subject.raw("foo:bar", "spam:eggs")
        expect(subject.clauses).to eq(["foo:bar", "spam:eggs"])
      end
    end

    describe "#present(field)" do
      it "should add a \"field present\" clause" do
        subject.present("foo")
        expect(subject.clauses).to eq(["foo:[* TO *]"])
      end
    end

    describe "#absent(field)" do
      it "should add a \"field not present\" clause" do
        subject.absent("foo")
        expect(subject.clauses).to eq(["-foo:[* TO *]"])
      end
    end

    describe "#before_days(field, days)" do
      it "should add a date range query clause" do
        subject.before_days("foo", 60)
        expect(subject.clauses).to eq(["foo:[* TO NOW-60DAYS]"])
      end
    end

    describe "#before(field, date_time)" do
      it "should add a date range query clause" do
        subject.before("foo", DateTime.parse("Thu, 27 Aug 2015 17:42:34 -0400"))
        expect(subject.clauses).to eq(["foo:[* TO 2015-08-27T21:42:34Z]"])
      end
    end

  end
end
