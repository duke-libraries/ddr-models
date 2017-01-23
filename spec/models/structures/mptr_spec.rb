require 'spec_helper'

module Ddr::Models::Structures
  RSpec.describe Mptr, type: :model, structure: true do

    let(:attrs) { { id: 'abc', loctype: 'OTHER', otherloctype: 'def', href: 'ijk' } }
    let(:doc) { Ddr::Models::Structure.xml_template }
    let(:node) do
      node = Nokogiri::XML::Node.new('mptr', doc)
      node['ID'] = attrs[:id]
      node['LOCTYPE'] = attrs[:loctype]
      node['OTHERLOCTYPE'] = attrs[:otherloctype]
      node['xlink:href'] = attrs[:href]
      doc.root.add_child(node)
      node
    end

    describe ".build" do
      it "should build the correct node" do
        expect(described_class.build(attrs.merge(document: doc)).to_xml).to be_equivalent_to(node.to_xml)
      end
    end

  end
end
