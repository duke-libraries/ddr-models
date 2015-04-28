require 'spec_helper'

module Ddr
  module Models
    RSpec.describe HasStructMetadata, type: :model do

      context "component" do
        describe "component creation" do
          let(:item) { Item.new }
          let(:comp) { Component.new(identifier: [ "id001" ]) }
          before do
            allow(comp).to receive(:parent).and_return(item)
            allow(comp).to receive(:has_content?).and_return(true)
            allow(comp).to receive(:content_type).and_return("image/tiff")
            allow(item).to receive(:children_by_file_use).and_return({})
          end
          it "should assign default values for unassigned attributes" do
            comp.save
            expect(comp.file_use).to_not be_nil
            expect(comp.order).to_not be_nil
            expect(comp.file_group).to_not be_nil
          end
          it "should not overwrite assigned attributes" do
            comp.update_attributes(file_use: 'foo', order: 3, file_group: 'special')
            expect(comp.file_use).to eq('foo')
            expect(comp.order).to eq(3)
            expect(comp.file_group).to eq('special')
          end
        end
      end

    end
  end
end
