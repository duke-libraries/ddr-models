require 'spec_helper'

module Ddr::Models::Structures
  RSpec.describe FileGrp, type: :model, structure: true do

    let(:attrs) { { id: 'abc', use: 'efg' } }
    let(:doc) { Ddr::Models::Structure.xml_template }
    let(:node) do
      node = Nokogiri::XML::Node.new('fileGrp', doc)
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

  end
end
