require 'spec_helper'

module Ddr::Models::Structures
  RSpec.describe MetsHdr, type: :model, structure: true do

    let(:attrs) { { id: 'abc', createdate: '2017-01-17T16:48:36Z', lastmoddate: '2017-01-18T16:46:48Z',
                    recordstatus: 'foo' } }
    let(:doc) { Ddr::Models::Structure.xml_template }
    let(:node) do
      node = Nokogiri::XML::Node.new('metsHdr', doc)
      node['ID'] = attrs[:id]
      node['CREATEDATE'] = attrs[:createdate]
      node['LASTMODDATE'] = attrs[:lastmoddate]
      node['RECORDSTATUS'] = attrs[:recordstatus]
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
