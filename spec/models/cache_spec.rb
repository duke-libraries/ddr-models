module Ddr::Models
  RSpec.describe Cache do

    describe "#get" do
      it "retrieves a value by key" do
        expect(subject.get(:foo)).to be_nil
        subject[:foo] = "bar"
        expect(subject.get(:foo)).to eq "bar"
      end
    end

    describe "#put" do
      it "inserts a key/value" do
        expect { subject.put(:foo, "bar") }.to change { subject[:foo] }.from(nil).to("bar")
      end
    end

    describe "#with" do
      it "returns the value of the block" do
        result = subject.with(foo: "bar") { 1 }
        expect(result).to eq 1
      end
      it "temporarily caches the arguments" do
        subject.with(foo: "bar") do
          expect(subject.get(:foo)).to eq "bar"
        end
        expect(subject.get(:foo)).to be_nil
      end
    end

  end
end
