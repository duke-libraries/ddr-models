require 'spec_helper'

module Ddr::Models::Structures
  RSpec.describe File, type: :model, structure: true do

    let(:attrs) { { id: 'abc', use: 'efg' } }
    let(:doc) { Ddr::Models::Structure.xml_template }
    let(:node) do
      node = Nokogiri::XML::Node.new('file', doc)
      node['ID'] = attrs[:id]
      node['USE'] = attrs[:use]
      doc.root.add_child(node)
      node
    end

    describe ".build" do
      it "should build the correct node" do
        expect(described_class.build(attrs.merge(document: doc)).to_xml).to be_equivalent_to(node.to_xml)
      end
    end

    describe ".find" do
      let(:structure) { FactoryGirl.build(:simple_structure) }
      it "finds the requested File" do
        expect(File.find(structure, 'def')).to be_a(File)
        expect(File.find(structure, 'def').id).to eq('def')
      end
    end

    describe "effective use" do
      before do
        allow(subject).to receive(:parent) { Nokogiri::XML::Node.new('fileGrp', doc) }
      end
      describe "use attribute present" do
        subject { described_class.new(node) }
        its(:effective_use) { is_expected.to eq(subject.use) }
      end
      describe "use attribute not present" do
        before do
          allow(subject).to receive(:use) { nil }
        end
        describe "parent node has effective use" do
          subject { described_class.new(node) }
          before do
            allow_any_instance_of(FileGrp).to receive(:effective_use) { 'xyz' }
          end
          its(:effective_use) { is_expected.to eq('xyz') }
        end
        describe "parent node does not have an effective use" do
          subject { described_class.new(node) }
          before do
            allow_any_instance_of(FileGrp).to receive(:effective_use) { nil }
          end
          its(:effective_use) { is_expected.to be_nil }
        end
      end
    end

  end
end
