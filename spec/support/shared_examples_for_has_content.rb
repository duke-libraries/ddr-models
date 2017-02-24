require 'openssl'

RSpec.shared_examples "an object that can have content" do

  subject { described_class.new(title: [ "I Have Content!" ]) }

  before { allow(Resque).to receive(:enqueue) }

  its(:can_have_content?) { is_expected.to be true }
  it { is_expected.to_not have_content }
  specify {
    allow(subject.content).to receive(:has_content?) { true }
    expect(subject).to have_content
  }

  its(:can_have_children?) { is_expected.to be false }
  it { is_expected.to_not have_children }

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

  describe "indexing" do
    let(:file) { fixture_file_upload("imageA.tif", "image/tiff") }
    before { subject.upload file }
    it "should index the content ds control group" do
      expect(subject.to_solr).to include(Ddr::Index::Fields::CONTENT_CONTROL_GROUP)
    end
  end

  describe "extracted text" do
    describe "when it is not present" do
      its(:has_extracted_text?) { should be false }
      its(:to_solr) { is_expected.not_to include(Ddr::Index::Fields::EXTRACTED_TEXT) }
    end
    describe "when it is present" do
      before { subject.extractedText.content = "This is my text. See Spot run." }
      its(:has_extracted_text?) { should be true }
      its(:to_solr) { is_expected.to include(Ddr::Index::Fields::EXTRACTED_TEXT) }
    end
  end

  describe "adding a file" do
    let(:file) { fixture_file_upload("imageA.tif", "image/tiff") }
    before { subject.add_file file, "content" }
    its(:original_filename) { should eq("imageA.tif") }
    its(:content_type) { should eq("image/tiff") }
    it "should create a 'virus check' event for the object" do
      expect(Ddr::Events::VirusCheckEvent).to receive(:create)
      subject.save!
    end
  end

  describe "save" do
    describe "when new content is present" do
      context "and it's a new object" do
        before { subject.add_file file, "content" }
        let(:file) { fixture_file_upload("imageA.tif", "image/tiff") }
        it "should generate derivatives" do
          expect_any_instance_of(Ddr::Managers::DerivativesManager).to receive(:update_derivatives)
          subject.save
        end
      end

      context "and it's an existing object with content" do
        before { subject.upload! fixture_file_upload('imageA.tif', 'image/tiff') }
        let(:file) { fixture_file_upload("imageB.tif", "image/tiff") }
        it "should generate derivatives" do
          expect_any_instance_of(Ddr::Managers::DerivativesManager).to receive(:update_derivatives)
          subject.upload! file
        end
        context "and the file has not previously been characterized" do
          it "does not try to delete the existing characterization data" do
            expect(subject.fits).not_to receive(:delete)
            subject.upload! file
          end
        end
        context "and the file has new characterization data" do
          before {
            subject.fits.content = fixture_file_upload("fits/document.xml")
          }
          it "preserves the characterization data" do
            subject.upload! file
            expect(subject.reload.fits).to have_content
          end
        end
      end
    end
  end

  describe "#upload" do
    let(:file) { fixture_file_upload("imageA.tif", "image/tiff") }
    it "should add the file to the content datastream" do
      expect(subject).to receive(:add_file).with(file, "content", {})
      subject.upload(file)
    end
  end

  describe "#upload!" do
    let(:file) { fixture_file_upload("imageA.tif", "image/tiff") }
    it "should add the file to the content datastream and save the object" do
      expect(subject).to receive(:add_file).with(file, "content", {}).and_call_original
      expect(subject).to receive(:save)
      subject.upload!(file)
    end
  end

  describe "deleting / deaccessioning" do
    let(:file1) { fixture_file_upload("sample.pdf") }
    let(:file2) { fixture_file_upload("sample.docx") }
    before do
      subject.upload! file1
      @path1 = subject.content.file_path
      subject.upload! file2
      @path2 = subject.content.file_path
    end
    describe "#destroy" do
      it "deletes the content files" do
        expect(::File.exist?(@path1)).to be true
        expect(::File.exist?(@path2)).to be true
        subject.destroy
        expect(::File.exist?(@path1)).to be false
        expect(::File.exist?(@path2)).to be false
      end
    end
    describe "#deaccession" do
      it "deletes the content files" do
        expect(::File.exist?(@path1)).to be true
        expect(::File.exist?(@path2)).to be true
        subject.deaccession
        expect(::File.exist?(@path1)).to be false
        expect(::File.exist?(@path2)).to be false
      end
    end
    describe "deleting the 'content' datastream" do
      it "deletes the content files" do
        expect(::File.exist?(@path1)).to be true
        expect(::File.exist?(@path2)).to be true
        subject.content.delete
        expect(::File.exist?(@path1)).to be false
        expect(::File.exist?(@path2)).to be false
      end
    end
  end

end
