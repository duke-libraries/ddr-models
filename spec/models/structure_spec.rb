require 'spec_helper'
require 'support/structural_metadata_helper'

module Ddr
  module Models
    RSpec.describe Structure, type: :model, structural_metadata: true do

      describe "#struct_divs" do
        let(:structure) { FactoryGirl.build(:multiple_struct_maps_structure) }
        let(:struct_divs) { structure.struct_divs }
        it "should include struct divs for each struct map" do
          expect(struct_divs.keys).to match_array([ 'default', 'reverse' ])
          expect(struct_divs['default']).to be_a(Ddr::Models::StructDiv)
          expect(struct_divs['reverse']).to be_a(Ddr::Models::StructDiv)
        end
      end

    end
  end
end