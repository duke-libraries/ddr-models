require 'spec_helper'

module Ddr::Models
  RSpec.describe HasThumbnail, type: :model do

    let(:component) { Component.new }
    let(:item) { Item.new }

    describe '#copy_thumbnail_from' do
      describe 'other has thumbnail' do
        before do
          component.thumbnail.content = 'abcdef'
          component.thumbnail.mime_type = 'image/png'
        end
        it "should copy the thumbnail content and mime type" do
          result = item.copy_thumbnail_from(component)
          expect(result).to be(true)
          expect(item.thumbnail.content).to eq('abcdef')
          expect(item.thumbnail.mime_type).to eq('image/png')
        end
      end
      describe 'other does not hav thumbnail' do
        it "should copy the thumbnail content and mime type" do
          result = item.copy_thumbnail_from(component)
          expect(result).to be(false)
          expect(item.thumbnail.content).to be_nil
        end
      end
    end

  end
end
