require 'spec_helper'
require 'support/structural_metadata_helper'

module Ddr
  module Models
    RSpec.describe Structure, type: :model, structural_metadata: true do

      describe "#struct_maps" do
        let(:structure) { FactoryGirl.build(:multiple_struct_maps_structure) }
        let(:struct_maps) { structure.struct_maps }
        it "should include struct divs for each struct map" do
          expect(struct_maps.keys).to match_array([ 'default', 'reverse' ])
          expect(struct_maps['default']).to be_a(Ddr::Models::StructDiv)
          expect(struct_maps['reverse']).to be_a(Ddr::Models::StructDiv)
        end
      end

      describe "#fptr_nodes" do
        let(:structure) { FactoryGirl.build(:nested_structure) }
        it "should return all fptr nodes" do
          results = structure.fptr_nodes
          expect(results.size).to eq(3)
          ids = results.map { |entry| entry['CONTENTIDS'] }
          expect(ids).to match_array([ 'info:fedora/test:5', 'info:fedora/test:6', 'info:fedora/test:7' ])
        end
      end

    end
  end
end
