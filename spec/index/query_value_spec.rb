module Ddr::Index
  RSpec.describe QueryValue do

    describe ".or_values" do
      describe "when argument is nil" do
        it "raises an exception" do
          expect { described_class.or_values(nil) }.to raise_error(ArgumentError)
        end
      end
      describe "when argument is empty" do
        it "raises an exception" do
          expect { described_class.or_values([]) }.to raise_error(ArgumentError)
        end
      end
      describe "when argument is not enumerable" do
        it "raises an exception" do
          expect { described_class.or_values("foo") }.to raise_error(ArgumentError)
        end
      end
      describe "when argument size == 1" do
        it "returns the first value, escaped" do
          expect(described_class.or_values(["foo:bar"])).to eq("(foo\\:bar)")
        end
      end
      describe "when argument size > 1" do
        it "return the escaped values OR'd together in parentheses" do
          expect(described_class.or_values(["foo:bar", "spam:eggs"])).to eq("(foo\\:bar OR spam\\:eggs)")
        end
      end
    end

  end
end
