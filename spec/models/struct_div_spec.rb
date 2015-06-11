require 'spec_helper'
require 'support/structural_metadata_helper'

module Ddr
  module Models
    RSpec.describe StructDiv, type: :model, structural_metadata: true do

      # let(:structure) { FactoryGirl.build(:simple_structure) }
      # let(:structDiv) { structure.struct_div_map['default'] }
      let(:structmap_node) { nested_structure_document.xpath('//xmlns:structMap').first }
      let(:struct_div) { described_class.new(structmap_node) }

      describe "#initialize" do
        it "should create the correct object" do
          expect(struct_div.divs.size).to eq(2)
          expect(struct_div.divs.first.label).to eq("Front")
          expect(struct_div.divs.first.divs).to be_empty
          expect(struct_div.divs.first.objs).to eq([ "test:5" ])
          expect(struct_div.divs.last.label).to eq("Back")
          expect(struct_div.divs.last.divs.size).to eq(2)
          expect(struct_div.divs.last.objs).to be_empty
          expect(struct_div.divs.last.divs.first.label).to eq("Top")
          expect(struct_div.divs.last.divs.first.divs).to be_empty
          expect(struct_div.divs.last.divs.first.objs).to eq([ "test:7" ])
          expect(struct_div.divs.last.divs.last.label).to eq("Bottom")
          expect(struct_div.divs.last.divs.last.divs).to be_empty
          expect(struct_div.divs.last.divs.last.objs).to eq([ "test:6" ])
        end
      end

      describe "#objects?" do
        context "objects" do
          it "should be true" do
            expect(struct_div.divs[0].objects?).to be_truthy
          end
        end
        context "no objects" do
          it "should be false" do
            expect(struct_div.objects?).to_not be_truthy
          end
        end
      end
      
      describe "#object_pids" do
        it "should return the object pids in order" do
          expect(struct_div.divs.last.divs.first.object_pids).to eq([ 'test:7' ])
          expect(struct_div.divs.last.divs.last.object_pids).to eq([ 'test:6' ])
        end
      end

      describe "#objects" do
        let(:repo_objects) { [ Component.new(pid: 'test:6'), Component.new(pid: 'test:7') ] }
        before do
          allow(ActiveFedora::Base).to receive(:find).with('test:6') { repo_objects.first }
          allow(ActiveFedora::Base).to receive(:find).with('test:7') { repo_objects.last }
        end
        it "should return the Active Fedora objects in order" do
          expect(struct_div.divs.last.divs.first.objects).to eq([ repo_objects.last ])
          expect(struct_div.divs.last.divs.last.objects).to eq([ repo_objects.first ])
        end
      end

    end
  end
end