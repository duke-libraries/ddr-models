module Ddr::Models
  RSpec.describe YearFacet do

    subject { described_class.new(obj) }
    let(:obj) { Item.new }
    before { obj.date = [ date ] }

    describe "splitting on semicolons" do
      let(:date) { "1935; 1936; 1937; 1938" }
      its(:values) { is_expected.to eq([1935, 1936, 1937, 1938]) }
    end

    describe "year range" do
      %w( 1935-1940 1935/1940 ).each do |value|
        describe value do
          let(:date) { value }
          its(:values) { is_expected.to eq((1935..1940).to_a) }
        end
      end
    end

    describe "in decade" do
      %w( 192x 192X 192? 192- 192-? ).each do |value|
        describe value do
          let(:date) { value }
          its(:values) { is_expected.to eq((1920..1929).to_a) }
        end
      end
    end

    describe "in century -- YYxx (19xx)" do
      let(:date) { "19xx" }
      its(:values) { is_expected.to eq((1900..1999).to_a) }
    end

    describe "decade" do
      %w( 1920s 1920s? ).each do |value|
        describe value do
          let(:date) { value }
          its(:values) { is_expected.to eq((1920..1929).to_a) }
        end
      end
    end

    describe "year + month" do
      %w( 2010-01 2010/01 ).each do |value|
        describe value do
          let(:date) { value }
          its(:values) { is_expected.to eq([2010]) }
        end
      end
    end

    describe "between" do
      let(:date) { "Between 1965 and 1968" }
      its(:values) { is_expected.to eq((1965..1968).to_a) }
    end

    describe "year" do
      let(:date) { "1965" }
      its(:values) { is_expected.to eq([1965]) }
    end

  end
end
