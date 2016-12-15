module Ddr::Models
  RSpec.describe YearFacet do

    subject { described_class.call(obj) }
    let(:obj) { Item.new }
    before { obj.date = [ date ] }

    describe "splitting on semicolons" do
      let(:date) { "1935; 1936; 1937; 1938" }
      it { is_expected.to eq([1935, 1936, 1937, 1938]) }
    end

    describe "year range" do
      %w( 1935-1940 1935/1940 1935?/1940? 1935~/1940~ ).each do |value|
        describe value do
          let(:date) { value }
          it { is_expected.to eq((1935..1940).to_a) }
        end
      end
    end

    describe "decade" do
      %w( 192u 192x 192X 192? 192- 192-? 1920s 1920s? ).each do |value|
        describe value do
          let(:date) { value }
          it { is_expected.to eq((1920..1929).to_a) }
        end
      end
    end

    describe "century" do
      %w( 19xx 19uu ).each do |value|
        describe value do
          let(:date) { value }
          it { is_expected.to eq((1900..1999).to_a) }
        end
      end
    end

    describe "uncertain interval" do
      let(:date) { "199u/200u" }
      it { is_expected.to eq((1990..2009).to_a) }
    end

    describe "set" do
      let(:date) { "[1999,2000,2003]" }
      it { is_expected.to eq([1999, 2000, 2003]) }
    end

    describe "year" do
      %w( 2010 2010? 2010~ ).each do |value|
        describe value do
          let(:date) { value }
          it { is_expected.to eq([2010]) }
        end
      end
    end

    describe "month" do
      %w( 2010-01 2010/01 2010-12? 2010-11/2010-12 ).each do |value|
        describe value do
          let(:date) { value }
          it { is_expected.to eq([2010]) }
        end
      end
    end

    describe "day" do
      %w( 2010-12-10 2010-12-10? 2010-12-10/2010-12-20 ).each do |value|
        describe value do
          let(:date) { value }
          it { is_expected.to eq([2010]) }
        end
      end
    end

    describe "season" do
      %w( 2010-21 2010-22 2010-23 2010-24 ).each do |value|
        describe value do
          let(:date) { value }
          it { is_expected.to eq([2010]) }
        end
      end
    end

    describe "between" do
      let(:date) { "Between 1965 and 1968" }
      it { is_expected.to eq((1965..1968).to_a) }
    end

  end
end
