require 'spec_helper'

module Ddr::Models
  RSpec.describe MultiresImage do

    let(:file_path) { '/tmp/foo.txt' }

    describe 'initialization' do
      context "mime_type not provided" do
        subject { MultiresImage.new(file_path) }
        its(:use) { is_expected.to eq(Ddr::Models::MultiresImage::USE) }
        its(:resource_type) { is_expected.to eq('Image') }
        its(:location) { is_expected.to eq("file:#{file_path}") }
        its(:mime_type) { is_expected.to be_nil }
      end
      context "mime_type provided" do
        subject { MultiresImage.new(file_path, mime_type: 'text/plain') }
        its(:use) { is_expected.to eq(Ddr::Models::MultiresImage::USE) }
        its(:resource_type) { is_expected.to eq('Image') }
        its(:location) { is_expected.to eq("file:#{file_path}") }
        its(:mime_type) { is_expected.to eq('text/plain') }
      end
    end

  end
end