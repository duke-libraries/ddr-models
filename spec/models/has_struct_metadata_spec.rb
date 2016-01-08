require 'spec_helper'

module Ddr
  module Models
    RSpec.describe HasStructMetadata, type: :model, structural_metadata: true do

      let(:item) { Item.new(id: 'test_2') }

      describe "#structure" do
        context "no existing structural metadata" do
          it "should return nil" do
            expect(item.structure).to eq(nil)
          end
        end
        context "existing structural metadata" do
          before { item.datastreams[Ddr::Datastreams::STRUCT_METADATA].content = simple_structure }
          it "should return the structural metadata" do
            expect(item.structure.to_xml).to be_equivalent_to(simple_structure)
          end
        end
      end

      describe "#build_default_structure" do
        let(:components) { [ Component.new(id: 'test_5', identifier: [ 'abc002' ]),
                             Component.new(id: 'test_6', identifier: [ 'abc001' ]),
                             Component.new(id: 'test_7', identifier: [ 'abc003' ])
                           ] }
        let(:expected) { FactoryGirl.build(:simple_structure) }
        before { allow(item).to receive(:find_children) { simple_structure_query_response } }
        it "should build the appropriate structural metadata" do
          results = item.build_default_structure
          expect(results).to be_equivalent_to(expected)
        end
      end

      describe "indexing" do
        let(:expected_json) { multiple_struct_maps_structure_to_json }
        before { item.datastreams[Ddr::Datastreams::STRUCT_METADATA].content = multiple_struct_maps_structure }
        it "should index the JSON representation of the structure" do
          indexing = item.to_solr
          expect(indexing.keys).to include(Ddr::Index::Fields::STRUCT_MAPS)
          expect(indexing[Ddr::Index::Fields::STRUCT_MAPS]).to eq(expected_json)
        end
      end

    end
  end
end