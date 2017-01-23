require 'spec_helper'

module Ddr::Models::Structures
  RSpec.describe Div, type: :model, structure: true do

    let(:attrs) { { id: 'abc', label: 'ghi', order: '5', orderlabel: 'def', type: 'pqr' } }
    let(:doc) { Ddr::Models::Structure.xml_template }
    let(:node) do
      node = Nokogiri::XML::Node.new('div', doc)
      node['ID'] = attrs[:id]
      node['LABEL'] = attrs[:label]
      node['ORDER'] = attrs[:order]
      node['ORDERLABEL'] = attrs[:orderlabel]
      node['TYPE'] = attrs[:type]
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
