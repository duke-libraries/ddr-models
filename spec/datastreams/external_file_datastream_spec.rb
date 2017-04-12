module Ddr::Datastreams
  RSpec.describe ExternalFileDatastream do

    let(:obj) { Component.new }
    let(:file1) { fixture_file_upload("sample.pdf", "application/pdf") }
    let(:file2) { fixture_file_upload("sample.docx") }

    subject { obj.content }

    its(:file_size) { is_expected.to be_nil }
    its(:file_path) { is_expected.to be_nil }
    its(:file_paths) { is_expected.to be_empty }

    specify {
      subject.add_file(file1.path, mime_type: file1.content_type)
      obj.save!
      path1 = subject.file_path
      expect(::File.exist?(path1)).to be true
      expect(subject.file_size).to eq 83777
      expect(subject.mimeType).to eq "application/pdf"
      subject.add_file(file2.path)
      obj.save!
      path2 = subject.file_path
      expect(::File.exist?(path2)).to be true
      expect(subject.file_size).to eq 12552
      expect(subject.mimeType).to eq "application/octet-stream"
      expect(subject.file_paths).to contain_exactly(path1, path2)
      subject.delete
      expect(::File.exist?(path1)).to be false
      expect(::File.exist?(path2)).to be false
      expect(subject.file_size).to be_nil
      expect(subject.dsLocation).to be_nil
      expect(subject.file_path).to be_nil
    }

    describe "checksum validation" do
      before do
        subject.add_file(file1.path, mime_type: file1.content_type)
        obj.save!
      end
      it "should not call Rubydora to retrieve datastream content" do
        expect(subject).to_not receive(:content)
        subject.validate_checksum!('a6ae0d815c1a2aef551b45fe34a35ceea1828a4d', Ddr::Datastreams::CHECKSUM_TYPE_SHA1)
      end
    end
  end
end
