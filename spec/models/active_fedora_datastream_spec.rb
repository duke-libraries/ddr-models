require 'spec_helper'

module ActiveFedora
  RSpec.describe Datastream do

    describe "#tempfile" do
      describe "when the datastream has no content" do
        it "should raise an exception" do
          expect { subject.tempfile { |f| puts f.path } }.to raise_error(Ddr::Models::Error)
        end
      end
      describe "when the datastream has content" do
        let(:file) { fixture_file_upload("sample.pdf", "application/pdf") }
        before do
          subject.content = file.read
          subject.mime_type = file.content_type
          allow(subject).to receive(:pid) { "test:1" }
        end
        describe "the yielded file" do
          it "should by default have an extension for the datastream media type" do
            subject.tempfile do |f|
              expect(f.path.end_with?(".pdf")).to be true
            end
          end
          it "should use the prefix provided" do
            subject.tempfile(prefix: "foo") do |f|
              expect(::File.basename(f.path).start_with?("foo")).to be true
            end
          end
          it "should use the sufffix provided" do
            subject.tempfile(suffix: "bar") do |f|
              expect(f.path.end_with?("bar")).to be true
            end
          end
          describe "default prefix" do
            describe "when the file has an id" do
              it "should start with the id" do
                allow(subject).to receive(:id) { "4f/78/97/71/4f789771-c663-466a-98a8-fd7c6fa0f452/foo" }
                subject.tempfile do |f|
                  expect(::File.basename(f.path).start_with?("4f_78_97_71_4f789771-c663-466a-98a8-fd7c6fa0f452_foo--")).to be true
                end
              end
            end
            describe "when the file has no id" do
              it "should be NEW" do
                subject.tempfile do |f|
                  expect(::File.basename(f.path).start_with?("NEW--")).to be true
                end
              end
            end
          end
          it "should have the same size as the datastream content" do
            subject.tempfile do |f|
              expect(f.size).to eq(subject.content.length)
            end
          end
        end
      end
    end

    describe "#validate_checksum!" do
      let!(:checksum) { "dea56f15b309e47b74fa24797f85245dda0ca3d274644a96804438bbd659555a" }
      let!(:checksum_type) { "SHA-256" }
      context "with unpersisted content" do
        context "the datstream is new" do
          before { allow(subject).to receive(:new_record?) { true } }
          it "should raise an exception" do
            expect { subject.validate_checksum!(checksum, checksum_type) }.to raise_error
          end
        end
        context "the datastream content has changed" do
          before { allow(subject).to receive(:content_changed?) { true } }
          it "should raise an exception" do
            expect { subject.validate_checksum!(checksum, checksum_type) }.to raise_error
          end
        end
      end
      context "with persisted content" do
        before do
          allow(subject).to receive(:new_record?) { false }
          allow(subject).to receive(:pid) { "foobar:1" }
          allow(subject).to receive(:dsCreateDate) { DateTime.now }
          allow(subject).to receive(:checksum) { checksum }
          allow(subject).to receive(:checksumType) { checksum_type }
        end
        context "and the repository internal checksum in invalid" do
          before { allow(subject).to receive(:dsChecksumValid) { false } }
          it "should raise an error" do
            expect { subject.validate_checksum!(checksum, checksum_type) }.to raise_error
          end
        end
        context "and the repository internal checksum is valid" do
          before { allow(subject).to receive(:dsChecksumValid) { true } }
          context "and the checksum type is invalid" do
            it "should raise an exception" do
              expect { subject.validate_checksum!("0123456789abcdef", "FOO-BAR") }.to raise_error
            end
          end
          context "and the checksum type is nil" do
            it "should compare the provided checksum with the datastream checksum" do
              expect { subject.validate_checksum!(checksum) }.not_to raise_error
            end
          end
          context "and the checksum type is the same as the datastream checksum type" do
            it "should compare the provided checksum with the datastream checksum" do
              expect { subject.validate_checksum!(checksum, checksum_type) }.not_to raise_error
            end
          end
          context "and the checksum type differs from the datastream checksum type" do
            let!(:md5digest) { "273ae0f4aa60d94e89bc0e0652ae2c8f" }
            it "should generate a checksum for comparison" do
              expect(subject).not_to receive(:checksum)
              allow(subject).to receive(:content_digest).with("MD5") { md5digest }
              expect { subject.validate_checksum!(md5digest, "MD5") }.not_to raise_error
            end
          end
          context "and the checksum doesn't match" do
            it "should raise an exception" do
              expect { subject.validate_checksum!("0123456789abcdef", checksum_type) }.to raise_error
            end
          end
        end
      end
    end

  end
end
