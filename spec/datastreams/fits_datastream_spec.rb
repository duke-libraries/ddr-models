require 'spec_helper'

module Ddr::Datastreams
  RSpec.describe FitsDatastream do

    let(:fits_xml) { fixture_file_upload(File.join("fits", "document.xml")) }

    before { subject.content = fits_xml.read }

    it "should exclude Exiftool from modified" do
      expect(subject.modified).to eq(["2016-01-07T14:49:50Z"])
    end

    describe "document metadata" do
      its(:has_annotations) { is_expected.to eq ["no"] }
      its(:is_protected)    { is_expected.to eq [] }
      its(:language)        { is_expected.to eq ["en"] }
      its(:page_count)      { is_expected.to eq ["283"] }
    end

    describe "image metadata" do
      let(:fits_xml) { fixture_file_upload(File.join("fits", "image.xml")) }

      its(:color_space)         { is_expected.to eq ["YCbCr"] }
      its(:icc_profile_name)    { is_expected.to eq ["c2"] }
      its(:icc_profile_version) { is_expected.to eq ["2.1.0"] }
      its(:image_height)        { is_expected.to eq ["583"] }
      its(:image_width)         { is_expected.to eq ["512"] }
    end

  end
end
