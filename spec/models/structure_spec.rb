require 'spec_helper'
require 'support/structural_metadata_helper'

module Ddr
  module Models
    RSpec.describe Structure, type: :model, structural_metadata: true do

      let(:structure) { FactoryGirl.build(:multiple_struct_maps_structure) }

      describe "#struct_maps" do
        let(:struct_maps) { structure.struct_maps }
        it "should include struct divs for each struct map" do
          expect(struct_maps.keys).to match_array([ 'default', 'reverse' ])
          expect(struct_maps['default']).to be_a(Ddr::Models::StructDiv)
          expect(struct_maps['reverse']).to be_a(Ddr::Models::StructDiv)
        end
      end

    end
  end
end