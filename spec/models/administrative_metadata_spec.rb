require 'spec_helper'

module Ddr::Models
  RSpec.describe AdministrativeMetadata do

    let(:obj) { FactoryGirl.build(:item) }

    describe ".property_term" do
      it "should return the correct property term" do
        expect(described_class.property_term(:local_id)).to eq(:local_id)
        expect(described_class.property_term('local_id')).to eq(:local_id)
      end
    end

    describe "using the set_values and add_value methods" do
      let(:ds) { described_class.new(obj) }
      before { ds.local_id = 'foo001' }
      describe "#set_values" do
        it "should set the value of the term to the one supplied" do
          ds.set_value :local_id, 'bar002'
          expect(ds.local_id).to eq('bar002')
        end
      end
      describe "#add_value" do
        it "should set the term value to the supplied value" do
          ds.add_value :local_id, 'bar002'
          expect(ds.local_id).to eq('bar002')
        end
      end
    end
  end
end
