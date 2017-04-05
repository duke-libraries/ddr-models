require 'spec_helper'

module Ddr::Models::Structures
  RSpec.describe FLocat, type: :model, structure: true do

    let(:attrs) { { id: 'abc', loctype: 'OTHER', use: 'def', href: 'ijk' } }
    let(:doc) { Ddr::Models::Structure.xml_template }
    let(:node) do
      node = Nokogiri::XML::Node.new('FLocat', doc)
      node['ID'] = attrs[:id]
      node['LOCTYPE'] = attrs[:loctype]
      node['USE'] = attrs[:use]
      node['xlink:href'] = attrs[:href]
      doc.root.add_child(node)
      node
    end

    describe ".build" do
      it "should build the correct node" do
        expect(described_class.build(attrs.merge(document: doc)).to_xml).to be_equivalent_to(node.to_xml)
      end
    end

    describe "location" do
      describe "is not an ARK" do
        subject { described_class.new(node) }
        its(:ark?) { is_expected.to eq(false) }
        its(:ark) { is_expected.to be_nil }
        its(:repo_id) { is_expected.to be_nil }
      end
      describe "is an ARK" do
        let(:node) do
          node = Nokogiri::XML::Node.new('FLocat', doc)
          node['LOCTYPE'] = 'ARK'
          node['xlink:href'] = 'ark:/99999/fk4edf'
          doc.root.add_child(node)
          node
        end
        let(:repo_object) { Item.create }
        before { repo_object.update_attributes(permanent_id: 'ark:/99999/fk4edf') }
        subject { described_class.new(node) }
        its(:ark?) { is_expected.to eq(true) }
        its(:ark) { is_expected.to eq('ark:/99999/fk4edf') }
        its(:repo_id) { is_expected.to eq(repo_object.id) }
      end
    end

    describe "effective use" do
      before do
        allow(subject).to receive(:parent) { Nokogiri::XML::Node.new('file', doc) }
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
            allow_any_instance_of(File).to receive(:effective_use) { 'xyz' }
          end
          its(:effective_use) { is_expected.to eq('xyz') }
        end
        describe "parent node does not have an effective use" do
          subject { described_class.new(node) }
          before do
            allow_any_instance_of(File).to receive(:effective_use) { nil }
          end
          its(:effective_use) { is_expected.to be_nil }
        end
      end
    end

  end
end
