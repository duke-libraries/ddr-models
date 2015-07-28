require 'spec_helper'

module Ddr::Managers
  RSpec.describe TechnicalMetadataManager do

    subject { described_class.new(obj) }

    let(:obj) { Component.new }

    describe "common metadata" do
      before do
        obj.fits.content = fixture_file_upload(File.join("fits", "document.xml"))
      end
      its(:valid) { is_expected.to eq(["false"]) }
      its(:well_formed) { is_expected.to eq(["true"]) }
      its(:file_size) { is_expected.to eq(["3786205"]) }
      its(:format_label) { is_expected.to eq(["Portable Document Format"]) }
      its(:mimetype) { is_expected.to eq(["application/pdf"]) }
      its(:format_version) { is_expected.to eq(["1.6"]) }
      its(:lastmodified) { is_expected.to contain_exactly("2015:06:25 21:45:24-04:00", "2015-06-08T21:22:35Z") }
      its(:created) { is_expected.to eq(["2015:06:05 15:16:23-04:00"]) }
      its(:pronom_identifier) { is_expected.to eq(["fmt/20"]) }
      its(:creating_application) { is_expected.to contain_exactly("Adobe Acrobat Pro 11.0.3 Paper Capture Plug-in/PREMIS Editorial Committee", "Adobe Acrobat Pro 11.0.3 Paper Capture Plug-in/Acrobat PDFMaker 11 for Word") }
      its(:fits_version) { is_expected.to eq("0.8.5") }
    end

    describe "image metadata" do
      before do
        obj.fits.content = fixture_file_upload(File.join("fits", "image.xml"))
      end
      its(:image_width) { is_expected.to eq(["500"]) }
      its(:image_height) { is_expected.to eq(["569"]) }
      its(:color_space) { is_expected.to eq(["YCbCr"]) }
    end

  end
end
