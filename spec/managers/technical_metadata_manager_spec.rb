require 'spec_helper'

module Ddr::Managers
  RSpec.describe TechnicalMetadataManager do

    subject { described_class.new(obj) }

    let(:obj) { Component.new }

    describe "when fits datastream not present" do
      its(:fits?) { is_expected.to be false }

      its(:created) { is_expected.to be_empty }
      its(:creating_application) { is_expected.to be_empty }
      its(:creation_time) { is_expected.to be_empty }
      its(:file_size) { is_expected.to be_empty }
      its(:fits_datetime) { is_expected.to be_nil }
      its(:fits_version) { is_expected.to be_nil }
      its(:format_label) { is_expected.to be_empty }
      its(:format_version) { is_expected.to be_empty }
      its(:last_modified) { is_expected.to be_empty }
      its(:md5) { is_expected.to be_nil }
      its(:media_type) { is_expected.to be_empty }
      its(:modification_time) { is_expected.to be_empty }
      its(:pronom_identifier) { is_expected.to be_empty }
      its(:valid) { is_expected.to be_empty }
      its(:well_formed) { is_expected.to be_empty }
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

      its(:created) { is_expected.to eq(["2015:12:09 13:23:09-05:00"]) }
      its(:creating_application) { is_expected.to contain_exactly("Adobe PDF Library 11.0/Acrobat PDFMaker 11 for Word") }
      its(:extent) { is_expected.to eq(["2176353"]) }
      its(:file_size) { is_expected.to eq([2176353]) }
      its(:fits_version) { is_expected.to eq("1.2.0") }
      its(:format_label) { is_expected.to eq(["Portable Document Format"]) }
      its(:format_version) { is_expected.to eq(["1.6"]) }
      its(:last_modified) { is_expected.to eq(["2016-01-07T14:49:50Z"]) }
      its(:md5) { is_expected.to eq("58fee04df34490ee7ecf3cdd5ddafc72") }
      its(:media_type) { is_expected.to eq(["application/pdf"]) }
      its(:pronom_identifier) { is_expected.to eq(["fmt/20"]) }
      its(:valid) { is_expected.to eq(["true"]) }
      its(:well_formed) { is_expected.to eq(["true"]) }

      describe "datetime fields" do
        its(:creation_time) { is_expected.to contain_exactly(DateTime.parse("2015-12-09 13:23:09-05:00").to_time.utc) }
        its(:modification_time) { is_expected.to contain_exactly(DateTime.parse("2016-01-07T14:49:50Z").to_time.utc) }
      end
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
      its(:image_width) { is_expected.to eq(["512"]) }
      its(:image_height) { is_expected.to eq(["583"]) }
      its(:color_space) { is_expected.to eq(["YCbCr"]) }
      its(:icc_profile_name) { is_expected.to eq(["c2"]) }
      its(:icc_profile_version) { is_expected.to eq(["2.1.0"]) }
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
