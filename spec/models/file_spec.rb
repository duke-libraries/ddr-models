require 'spec_helper'

module Ddr::Models
  RSpec.describe File do

    describe "versioning" do
      let(:obj) { FactoryGirl.build(:component) }
      describe "on create" do
        it "creates a version" do
          expect { obj.save }.to change { obj.content.has_versions? }.from(false).to(true)
          obj.save
          expect(obj.content.versions.all.size).to eq 1
        end
      end
      describe "on update" do
        it "creates a version" do
            obj.save
            expect {
              obj.upload fixture_file_upload("imageB.tif", "image/tiff")
              obj.save
            }.to change {
              obj.content.versions.all.size
            }.by(1)
        end
      end
    end

    describe "#tempfile" do
      describe "when the datastream has no content" do
        it "should raise an exception" do
          expect { subject.tempfile { |f| puts f.path } }.to raise_error(Error)
        end
      end
      describe "when the datastream has content" do
        let(:file) { fixture_file_upload("sample.pdf", "application/pdf") }
        before do
          subject.content = file.read
          subject.mime_type = file.content_type
          allow(subject).to receive(:id) { "test-1" }
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
                  expect(::File.basename(f.path).start_with?("4f_78_97_71_4f789771-c663-466a-98a8-fd7c6fa0f452_foo--"))
                    .to be true
                end
              end
            end
            describe "when the file has no id" do
              it "should be NEW" do
                allow(subject).to receive(:id) { nil }
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
      let(:checksum) { ActiveFedora::Checksum.new(obj) }
      let(:obj) { double(digest: [::RDF::URI("urn:sha1:bb3200c2ddaee4bd7b9a4dc1ad3e10ed886eaef1")]) }
      context "with unpersisted content" do
        context "the datstream is new" do
          before { allow(subject).to receive(:new_record?) { true } }
          it "should raise an exception" do
            expect { subject.validate_checksum!("bb3200c2ddaee4bd7b9a4dc1ad3e10ed886eaef1") }
              .to raise_error(Error)
          end
        end
        context "the datastream content has changed" do
          before { allow(subject).to receive(:content_changed?) { true } }
          it "should raise an exception" do
            expect { subject.validate_checksum!("bb3200c2ddaee4bd7b9a4dc1ad3e10ed886eaef1") }
              .to raise_error(Error)
          end
        end
      end
      context "with persisted content" do
        before do
          allow(subject).to receive(:new_record?) { false }
          allow(subject).to receive(:id) { "foobar-1" }
          allow(subject).to receive(:checksum) { checksum }
        end
        context "and the repository internal checksum in invalid" do
          before { allow(subject).to receive(:check_fixity) { false } }
          it "should raise an error" do
            expect { subject.validate_checksum!(checksum.value, checksum.algorithm) }
              .to raise_error(ChecksumInvalid)
          end
        end
        context "and the repository internal checksum is valid" do
          before { allow(subject).to receive(:check_fixity) { true } }
          context "and the checksum type is invalid" do
            before { allow(subject).to receive(:content) { double } }
            it "should raise an exception" do
              expect { subject.validate_checksum!("0123456789abcdef", "FOO-BAR") }
                .to raise_error(ArgumentError)
            end
          end
          context "and the checksum type is nil" do
            it "should compare the provided checksum with the datastream checksum" do
              expect { subject.validate_checksum!(checksum.value) }.not_to raise_error
            end
          end
          context "and the checksum type is the same as the datastream checksum type" do
            it "should compare the provided checksum with the datastream checksum" do
              expect { subject.validate_checksum!(checksum.value, checksum.algorithm) }.not_to raise_error
            end
          end
          context "and the checksum type differs from the datastream checksum type" do
            let!(:md5digest) { "273ae0f4aa60d94e89bc0e0652ae2c8f" }
            it "should generate a checksum for comparison" do
              allow(subject).to receive(:content_digest).with("MD5") { md5digest }
              expect { subject.validate_checksum!(md5digest, "MD5") }.not_to raise_error
            end
          end
          context "and the checksum doesn't match" do
            it "should raise an exception" do
              expect { subject.validate_checksum!("0123456789abcdef", checksum.algorithm) }
                .to raise_error(ChecksumInvalid)
            end
          end
        end
      end
    end

  end
end
