require 'spec_helper'

RSpec.describe Ddr::Services::Antivirus, services: true, antivirus: true do
  let(:file) { fixture_file_upload "library-devil.tiff" }
  describe ".scan" do
    context "when the db is already loaded" do
      before { allow(described_class).to receive(:loaded?) { true } }
      it "should reload the db" do
        expect(described_class).to receive(:reload!)
        described_class.scan file
      end
    end
    context "when the db is not already loaded" do
      before { allow(described_class).to receive(:loaded?) { false } }
      it "should load the db" do
        expect(described_class).to receive(:load!)
        described_class.scan file
      end
    end    
    it "should report whether there was an error" do
      expect(described_class.scan(file)).not_to be_error
    end
    context "when a virus is found" do
      before do
        allow(described_class).to receive(:scan_one).with(file.path) do
          Ddr::Services::Antivirus::ScanResult.new "Deadly Virus!", file.path
        end
      end
      it "should raise an execption" do
        expect { described_class.scan(file) }.to raise_error(Ddr::Models::VirusFoundError)
      end
    end
    context "when a virus is not found" do
      before do
        allow(described_class).to receive(:scan_one).with(file.path) do
          Ddr::Services::Antivirus::ScanResult.new 0, file.path
        end
      end
      it "the result should report that it does not have a virus" do
        expect(described_class.scan(file)).not_to have_virus
      end
    end
    context "when an error occurs in the engine" do
      before do
        allow(described_class).to receive(:scan_one).with(file.path) do
          Ddr::Services::Antivirus::ScanResult.new 1, file.path
        end
      end
      it "should raise an execption" do
        expect { described_class.scan(file) }.to raise_error(Ddr::Models::Error)
      end
    end
  end
end
