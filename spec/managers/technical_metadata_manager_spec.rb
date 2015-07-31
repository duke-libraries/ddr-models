require 'spec_helper'

module Ddr::Managers
  RSpec.describe TechnicalMetadataManager do

    subject { described_class.new(obj) }

    let(:obj) { Component.new }

    describe "when fits datastream not present" do
      its(:valid) { is_expected.to be_empty }
      its(:well_formed) { is_expected.to be_empty }
      its(:format_label) { is_expected.to be_empty }
      its(:media_type) { is_expected.to be_empty }
      its(:format_version) { is_expected.to be_empty }
      its(:last_modified) { is_expected.to be_empty }
      its(:created) { is_expected.to be_empty }
      its(:pronom_identifier) { is_expected.to be_empty }
      its(:creating_application) { is_expected.to be_empty }
      its(:file_size) { is_expected.to be_empty }
      its(:fits_version) { is_expected.to be_nil }
      its(:fits_datetime) { is_expected.to be_nil }
      its(:fits?) { is_expected.to be false }
    end

    describe "when content is not present" do
      its(:checksum_digest) { is_expected.to be_nil }
      its(:checksum_value) { is_expected.to be_nil }
    end

    describe "common metadata" do
      before do
        obj.fits.content = fixture_file_upload(File.join("fits", "document.xml"))
      end
      its(:fits?) { is_expected.to be true }
      its(:valid) { is_expected.to eq(["false"]) }
      its(:well_formed) { is_expected.to eq(["true"]) }
      its(:format_label) { is_expected.to eq(["Portable Document Format"]) }
      its(:media_type) { is_expected.to eq(["application/pdf"]) }
      its(:format_version) { is_expected.to eq(["1.6"]) }
      its(:last_modified) { is_expected.to contain_exactly("2015:06:25 21:45:24-04:00", "2015-06-08T21:22:35Z") }
      its(:created) { is_expected.to eq(["2015:06:05 15:16:23-04:00"]) }
      its(:pronom_identifier) { is_expected.to eq(["fmt/20"]) }
      its(:creating_application) { is_expected.to contain_exactly("Adobe Acrobat Pro 11.0.3 Paper Capture Plug-in/PREMIS Editorial Committee", "Adobe Acrobat Pro 11.0.3 Paper Capture Plug-in/Acrobat PDFMaker 11 for Word") }
      its(:fits_version) { is_expected.to eq("0.8.5") }
      its(:file_size) { is_expected.to eq(["3786205"]) }
      its(:media_type) { is_expected.to eq(["application/pdf"]) }
    end

    describe "checksum fields" do
      before do
        allow(obj.content).to receive(:checksumType) { "SHA-256" }
        allow(obj.content).to receive(:checksum) { "b744b4b308a11a7b6282b383ec428a91d77b21701d4bd09021bf0543dc8946fa" }
      end

      its(:checksum_digest) { is_expected.to eq("SHA-256") }
      its(:checksum_value) { is_expected.to eq("b744b4b308a11a7b6282b383ec428a91d77b21701d4bd09021bf0543dc8946fa") }
    end

    describe "image metadata" do
      before do
        obj.fits.content = fixture_file_upload(File.join("fits", "image.xml"))
      end
      its(:image_width) { is_expected.to eq(["500"]) }
      its(:image_height) { is_expected.to eq(["569"]) }
      its(:color_space) { is_expected.to eq(["YCbCr"]) }
    end

    describe "valid? / invalid?" do
      describe "when #valid has a 'false' value" do
        before do
          allow(subject).to receive(:valid) { ["false"] }
        end
        it { is_expected.to be_invalid }
        it { is_expected.not_to be_valid }
      end
      describe "when #valid has 'false' and 'true' values" do
        before do
          allow(subject).to receive(:valid) { ["false", "true"] }
        end
        it { is_expected.to be_invalid }
        it { is_expected.not_to be_valid }
      end
      describe "when #valid has a 'true' value" do
        before do
          allow(subject).to receive(:valid) { ["true"] }
        end
        it { is_expected.not_to be_invalid }
        it { is_expected.to be_valid }
      end
      describe "when #valid is empty" do
        before do
          allow(subject).to receive(:valid) { [] }
        end
        it { is_expected.not_to be_invalid }
        it { is_expected.to be_valid }
      end
    end

    describe "ill_formed? / well_formed?" do
      describe "when #well_formed has a 'false' value" do
        before do
          allow(subject).to receive(:well_formed) { ["false"] }
        end
        it { is_expected.to be_ill_formed }
        it { is_expected.not_to be_well_formed }
      end
      describe "when #well_formed has 'false' and 'true' values" do
        before do
          allow(subject).to receive(:well_formed) { ["false", "true"] }
        end
        it { is_expected.to be_ill_formed }
        it { is_expected.not_to be_well_formed }
      end
      describe "when #well_formed has a 'true' value" do
        before do
          allow(subject).to receive(:well_formed) { ["true"] }
        end
        it { is_expected.not_to be_ill_formed }
        it { is_expected.to be_well_formed }
      end
      describe "when #well_formed is empty" do
        before do
          allow(subject).to receive(:well_formed) { [] }
        end
        it { is_expected.not_to be_ill_formed }
        it { is_expected.to be_well_formed }
      end
    end

  end
end
