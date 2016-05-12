require 'spec_helper'

module Ddr
  module Models
    RSpec.describe FileManagement, :type => :model do

      let(:object) { Component.new }
      let(:file) { fixture_file_upload("imageA.tif", "image/tiff") }

      describe "#add_file" do
        it "should run a virus scan on the file" do
          expect(object).to receive(:virus_scan)
          object.add_file file, path: "m_content"
        end
        it "should set the mimeType" do
          object.add_file file, path: "m_content"
          expect(object.m_content.mime_type).to eq('image/tiff')
        end
      end

    end
  end
end
