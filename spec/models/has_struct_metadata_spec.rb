require 'spec_helper'

module Ddr
  module Models
    RSpec.describe HasStructMetadata, type: :model, structural_metadata: true do

      describe "#structure" do
        let(:item) { Item.new(pid: 'test:2') }
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
        let(:item) { Item.new(pid: 'test:2') }
        let(:components) { [ Component.new(pid: 'test:5', identifier: [ 'abc002' ]),
                             Component.new(pid: 'test:6', identifier: [ 'abc001' ]),
                             Component.new(pid: 'test:7', identifier: [ 'abc003' ])
                           ] }
        let(:expected) { FactoryGirl.build(:simple_structure) }
        before { allow(item).to receive(:find_children) { simple_structure_query_response } }
        it "should build the appropriate structural metadata" do
          results = item.build_default_structure
          expect(results).to be_equivalent_to(expected)
        end
      end

    end
  end
end