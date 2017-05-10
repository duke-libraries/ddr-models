module Ddr::Models
  RSpec.describe HasStructMetadata, type: :model, structural_metadata: true do

    let(:item) { Item.new(pid: 'test:2') }

    describe "#structures" do
      context "no existing structural metadata" do
        it "should return nil" do
          expect(item.structure).to eq(nil)
        end
      end
      context "existing structural metadata" do
        before { item.datastreams[Ddr::Datastreams::STRUCT_METADATA].content = simple_structure_xml }
        it "should return the structural metadata" do
          expect(item.structure.to_xml).to be_equivalent_to(simple_structure_xml)
        end
      end
    end

    describe "indexing" do
      let(:expected_json) { nested_structure_to_json }
      before do
        item.datastreams[Ddr::Datastreams::STRUCT_METADATA].content = nested_structure_xml
        flocat_x = instance_double("Structures::FLocat", effective_use: 'foo')
        flocat_y = instance_double("Structures::FLocat", effective_use: 'bar')
        flocat_z = instance_double("Structures::FLocat", effective_use: 'baz')
        file_a = instance_double("Structures::File", repo_ids: [ 'test:7' ], flocats: [ flocat_x ])
        file_b = instance_double("Structures::File", repo_ids: [ 'test:8' ], flocats: [ flocat_y ])
        file_c = instance_double("Structures::File", repo_ids: [ 'test:9' ], flocats: [ flocat_z ])
        allow(Structures::File).to receive(:find).with(an_instance_of(Ddr::Models::Structure), 'abc') { file_a }
        allow(Structures::File).to receive(:find).with(an_instance_of(Ddr::Models::Structure), 'def') { file_b }
        allow(Structures::File).to receive(:find).with(an_instance_of(Ddr::Models::Structure), 'ghi') { file_c }
      end
      it "should index the JSON representation of the structures" do
        indexing = item.to_solr
        expect(indexing[Ddr::Index::Fields::STRUCTURE]).to eq(expected_json)
      end
      describe "structure source" do
        describe "repository maintained" do
          before do
            item.datastreams[Ddr::Datastreams::STRUCT_METADATA].content = simple_structure_xml
          end
          it "should index the structure source as repository maintained" do
            indexing = item.to_solr
            expect(indexing[Ddr::Index::Fields::STRUCTURE_SOURCE]).to eq(Ddr::Models::Structure::REPOSITORY_MAINTAINED)
          end
        end
        describe "externally provided" do
          before do
            item.datastreams[Ddr::Datastreams::STRUCT_METADATA].content = nested_structure_xml
          end
          it "should index the structure source as repository maintained" do
            indexing = item.to_solr
            expect(indexing[Ddr::Index::Fields::STRUCTURE_SOURCE]).to eq(Ddr::Models::Structure::EXTERNALLY_PROVIDED)
          end
        end
      end
    end

  end
end
