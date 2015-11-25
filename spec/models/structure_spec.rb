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

      describe "#default_struct_map" do
        context "struct map with type 'default'" do
          let(:struct_map_xml) do
            <<-eos
              <mets xmlns="http://www.loc.gov/METS/" xmlns:xlink="http://www.w3.org/1999/xlink">
                <structMap TYPE="reverse">
                  <div ORDER="1" LABEL="Back">
                    <div ORDER="1" LABEL="Bottom">
                      <fptr CONTENTIDS="test_6" />
                    </div>
                    <div ORDER="2" LABEL="Top">
                      <fptr CONTENTIDS="test_7" />
                    </div>
                  </div>
                  <div ORDER="2" LABEL="Front">
                    <fptr CONTENTIDS="test_5" />
                  </div>
                </structMap>
                <structMap TYPE="default">
                  <div ORDER="1" LABEL="Front">
                    <fptr CONTENTIDS="test_5" />
                  </div>
                  <div ORDER="2" LABEL="Back">
                    <div ORDER="1" LABEL="Top">
                      <fptr CONTENTIDS="test_7" />
                    </div>
                    <div ORDER="2" LABEL="Bottom">
                      <fptr CONTENTIDS="test_6" />
                    </div>
                  </div>
                </structMap>
              </mets>
            eos
          end
          let(:struct_map_doc) do
            Nokogiri::XML(struct_map_xml) do |config|
              config.noblanks
            end
          end
          let(:structure) { Structure.new(struct_map_doc) }
          it "should return the struct map with type :default" do
            expect(structure.default_struct_map).to eq(structure.struct_maps['default'])
          end
        end
        context "no struct map with type 'default'" do
          let(:struct_map_xml) do
            <<-eos
              <mets xmlns="http://www.loc.gov/METS/" xmlns:xlink="http://www.w3.org/1999/xlink">
                <structMap TYPE="reverse">
                  <div ORDER="1" LABEL="Back">
                    <div ORDER="1" LABEL="Bottom">
                      <fptr CONTENTIDS="test_6" />
                    </div>
                    <div ORDER="2" LABEL="Top">
                      <fptr CONTENTIDS="test_7" />
                    </div>
                  </div>
                  <div ORDER="2" LABEL="Front">
                    <fptr CONTENTIDS="test_5" />
                  </div>
                </structMap>
                <structMap TYPE="other">
                  <div ORDER="1" LABEL="Front">
                    <fptr CONTENTIDS="test_5" />
                  </div>
                  <div ORDER="2" LABEL="Back">
                    <div ORDER="1" LABEL="Top">
                      <fptr CONTENTIDS="test_7" />
                    </div>
                    <div ORDER="2" LABEL="Bottom">
                      <fptr CONTENTIDS="test_6" />
                    </div>
                  </div>
                </structMap>
              </mets>
            eos
          end
          let(:struct_map_doc) do
            Nokogiri::XML(struct_map_xml) do |config|
              config.noblanks
            end
          end
          let(:structure) { Structure.new(struct_map_doc) }
          it "should return the first struct map" do
            expect(structure.default_struct_map).to eq(structure.struct_maps['reverse'])
          end
        end
      end

      describe "#default_struct_map_ids" do
        let(:structure) { FactoryGirl.build(:simple_structure) }
        it "should return the ids in order" do
          expect(structure.default_struct_map_ids).to match_array([ 'test_6', 'test_5', 'test_7' ])
        end
      end

    end
  end
end
