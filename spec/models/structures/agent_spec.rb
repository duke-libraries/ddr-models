require 'spec_helper'

module Ddr::Models::Structures
  RSpec.describe Agent, type: :model, structure: true do

    let(:attrs) { { id: 'abc', role: 'OTHER', otherrole: 'INVESTIGATOR', type: 'OTHER', othertype: 'SOMETHING',
                    name: 'Sam Spade' } }
    let(:doc) { Ddr::Models::Structure.xml_template }
    let(:node) do
      node = Nokogiri::XML::Node.new('agent', doc)
      node['ID'] = attrs[:id]
      node['ROLE'] = attrs[:role]
      node['OTHERROLE'] = attrs[:otherrole]
      node['TYPE'] = attrs[:type]
      node['OTHERTYPE'] = attrs[:othertype]
      doc.root.add_child(node)
      name_node = Nokogiri::XML::Node.new('name', doc)
      name_node.content = 'Sam Spade'
      node.add_child(name_node)
      node
    end

    describe ".build" do
      it "should build the correct node" do
        expect(described_class.build(attrs.merge(document: doc)).to_xml).to be_equivalent_to(node.to_xml)
      end
    end

  end
end
