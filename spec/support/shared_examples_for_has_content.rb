require 'spec_helper'
require 'openssl'

RSpec.shared_examples "an object that can have content" do

  subject { described_class.new(dc_title: [ "I Have Content!" ]) }

  before { allow(Resque).to receive(:enqueue) }

  it "should delegate :validate_checksum! to :content" do
    checksum = "dea56f15b309e47b74fa24797f85245dda0ca3d274644a96804438bbd659555a"
    expect(subject.content).to receive(:validate_checksum!).with(checksum, "SHA-256")
    subject.validate_checksum!(checksum, "SHA-256")
  end

  describe "last virus check" do
    let!(:virus_check) { Ddr::Events::VirusCheckEvent.new }
    before { allow(subject).to receive(:last_virus_check) { virus_check } }
    its(:last_virus_check_on) { should eq(virus_check.event_date_time) }
    its(:last_virus_check_outcome) { should eq(virus_check.outcome) }
  end

  describe "extracted text" do
    describe "when it is not present" do
      its(:has_extracted_text?) { should be false }
      its(:to_solr) { should_not include(Ddr::Index::Fields::EXTRACTED_TEXT) }
    end
    describe "when it is present" do
      before { subject.extractedText.content = "This is my text. See Spot run." }
      its(:has_extracted_text?) { should be true }
      it "should be indexed" do
        expect(subject.to_solr[Ddr::Index::Fields::EXTRACTED_TEXT]).to eq("This is my text. See Spot run.")
      end
    end
  end

  describe "adding a file" do
    let(:file) { fixture_file_upload("imageA.tif", "image/tiff") }
    context "defaults" do
      before { subject.add_file file, path: "content", mime_type: "image/tiff" }
      its(:content_type) { should eq("image/tiff") }
      it "should create a 'virus check' event for the object" do
        expect { subject.save }.to change { subject.virus_checks.count }
      end
    end
  end

  describe "save" do

    describe "when new content is present" do

      context "and it's a new object" do
        before { subject.add_file file, path: "content" }
        let(:file) { fixture_file_upload("imageA.tif", "image/tiff") }
        it "should generate derivatives" do
          expect(subject.derivatives).to receive(:update_derivatives)
          subject.save
        end
        describe "file characterization" do
          context "characterize files is false" do
            before { allow(Ddr::Models).to receive(:characterize_files?) { false } }
            it "should not enqueue a FITS file characterization job" do
              expect(Resque).to_not receive(:enqueue).with(Ddr::Jobs::FitsFileCharacterization, instance_of(String))
              subject.save
            end
          end
          context "characterize files is true" do
            before { allow(Ddr::Models).to receive(:characterize_files?) { true } }
            it "should enqueue a FITS file characterization job" do
              expect(Resque).to receive(:enqueue).with(Ddr::Jobs::FitsFileCharacterization, instance_of(String))
              subject.save
            end
          end
        end
      end

      context "and it's an existing object with content" do
        before { subject.upload! fixture_file_upload('imageA.tif', 'image/tiff') }
        let(:file) { fixture_file_upload("imageB.tif", "image/tiff") }
        it "should generate derivatives" do
          expect(subject.derivatives).to receive(:update_derivatives)
          subject.upload! file
        end
        describe "file characterization" do
          context "characterize files is false" do
            before { allow(Ddr::Models).to receive(:characterize_files?) { false } }
            it "should not enqueue a FITS file characterization job" do
              expect(Resque).to_not receive(:enqueue).with(Ddr::Jobs::FitsFileCharacterization, instance_of(String))
              subject.upload! file
            end
          end
          context "characterize files is true" do
            before { allow(Ddr::Models).to receive(:characterize_files?) { true } }
            it "should enqueue a FITS file characterization job" do
              expect(Resque).to receive(:enqueue).with(Ddr::Jobs::FitsFileCharacterization, instance_of(String))
              subject.upload! file
            end
          end
        end
      end
    end
  end

  describe "#upload" do
    let(:file) { fixture_file_upload("imageA.tif", "image/tiff") }
    it "should add the file to the content datastream" do
      expect(subject).to receive(:add_file).with(file, { path: "content", mime_type: "image/tiff" })
      subject.upload(file)
    end
  end

  describe "#upload!" do
    let(:file) { fixture_file_upload("imageA.tif", "image/tiff") }
    it "should add the file to the content datastream and save the object" do
      expect(subject).to receive(:add_file).with(file, { path: "content", mime_type: "image/tiff" }).and_call_original
      expect(subject).to receive(:save)
      subject.upload!(file)
    end
  end

end
