require 'spec_helper'
require 'support/structural_metadata_helper'

module Ddr
  module Models
    RSpec.describe StructDiv, type: :model, structural_metadata: true do

      let(:structmap_node) { nested_structure_document.xpath('//xmlns:structMap').first }
      let(:struct_div) { described_class.new(structmap_node) }

      describe "#initialize" do
        it "should create the correct object" do
          expect(struct_div.divs.size).to eq(2)
          expect(struct_div.divs.first.label).to eq("Front")
          expect(struct_div.divs.first.divs).to be_empty
          expect(struct_div.divs.first.fptrs).to eq([ "test_5" ])
          expect(struct_div.divs.last.label).to eq("Back")
          expect(struct_div.divs.last.divs.size).to eq(2)
          expect(struct_div.divs.last.fptrs).to be_empty
          expect(struct_div.divs.last.divs.first.label).to eq("Top")
          expect(struct_div.divs.last.divs.first.divs).to be_empty
          expect(struct_div.divs.last.divs.first.fptrs).to eq([ "test_7" ])
          expect(struct_div.divs.last.divs.last.label).to eq("Bottom")
          expect(struct_div.divs.last.divs.last.divs).to be_empty
          expect(struct_div.divs.last.divs.last.fptrs).to eq([ "test_6" ])
        end
      end

      describe "#pids" do
        context "top level" do
          it "should return all pids in the structMap" do
            expect(struct_div.pids).to match_array([ 'test_5', 'test_6', 'test_7' ])
          end
        end
      end

      describe "#docs" do
        let(:solr_response) { [ { 'id'=>'test_5' }, { 'id'=>'test_6' }, { 'id'=>'test_7'} ] }
        before do
          allow(ActiveFedora::SolrService).to receive(:query) { solr_response }
        end
        it "should return a hash of Solr documents" do
          results = struct_div.docs
          expect(results.keys).to match_array([ 'test_5', 'test_6', 'test_7' ])
          results.keys.each do |key|
            expect(results[key]).to be_a(SolrDocument)
            expect(results[key].id).to eq(key)
          end
        end
      end

      describe "#objects" do
        let(:repo_objects) { [ Component.new(id: 'test_5'), Component.new(id: 'test_6'), Component.new(id: 'test_7') ] }
        before do
          allow(ActiveFedora::Base).to receive(:find).with('test_5') { repo_objects[0] }
          allow(ActiveFedora::Base).to receive(:find).with('test_6') { repo_objects[1] }
          allow(ActiveFedora::Base).to receive(:find).with('test_7') { repo_objects[2] }
        end
        it "should return a hash of Active Fedora objects" do
          results = struct_div.objects
          expect(results.keys).to match_array([ 'test_5', 'test_6', 'test_7' ])
          expect(results['test_5']).to eq(repo_objects[0])
          expect(results['test_6']).to eq(repo_objects[1])
          expect(results['test_7']).to eq(repo_objects[2])
        end
      end

    end
  end
end