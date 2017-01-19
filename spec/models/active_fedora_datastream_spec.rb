module ActiveFedora
  RSpec.describe Datastream do

    describe "#tempfile" do
      subject { described_class.new(nil, "DS1", controlGroup: "M") }
      describe "when the datastream has no content" do
        it "should raise an exception" do
          expect { subject.tempfile { |f| puts f.path } }.to raise_error(Ddr::Models::Error)
        end
      end
      describe "when the datastream has content" do
        let(:file) { fixture_file_upload("sample.pdf", "application/pdf") }
        before do
          subject.content = file.read
          subject.mimeType = file.content_type
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
              expect(File.basename(f.path).start_with?("foo")).to be true
            end
          end
          it "should use the sufffix provided" do
            subject.tempfile(suffix: "bar") do |f|
              expect(f.path.end_with?("bar")).to be true
            end
          end
          it "should by default have a prefix based on the PID" do
            subject.tempfile do |f|
              expect(File.basename(f.path).start_with?("test_1_DS1--")).to be true
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
      subject { described_class.new(nil, nil, controlGroup: "M") }
      let!(:checksum) { "dea56f15b309e47b74fa24797f85245dda0ca3d274644a96804438bbd659555a" }
      let!(:checksum_type) { "SHA-256" }
      context "with unpersisted content" do
        context "the datstream is new" do
          before { allow(subject).to receive(:new?) { true } }
          it "should raise an exception" do
            expect { subject.validate_checksum!(checksum, checksum_type) }.to raise_error(Ddr::Models::Error)
          end
        end
        context "the datastream content has changed" do
          before { allow(subject).to receive(:content_changed?) { true } }
          it "should raise an exception" do
            expect { subject.validate_checksum!(checksum, checksum_type) }.to raise_error(Ddr::Models::Error)
          end
        end
      end
      context "with persisted content" do
        before do
          allow(subject).to receive(:new?) { false }
          allow(subject).to receive(:pid) { "foobar:1" }
          allow(subject).to receive(:dsCreateDate) { DateTime.now }
          allow(subject).to receive(:checksum) { checksum }
          allow(subject).to receive(:checksumType) { checksum_type }
        end
        context "and the repository internal checksum in invalid" do
          before { allow(subject).to receive(:dsChecksumValid) { false } }
          it "should raise an error" do
            expect { subject.validate_checksum!(checksum, checksum_type) }.to raise_error(Ddr::Models::ChecksumInvalid)
          end
        end
        context "and the repository internal checksum is valid" do
          before { allow(subject).to receive(:dsChecksumValid) { true } }
          context "and the checksum type is invalid" do
            before { allow(subject).to receive(:content) { "foo" } }
            it "should raise an exception" do
              expect { subject.validate_checksum!("0123456789abcdef", "FOO-BAR") }.to raise_error(ArgumentError)
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
              expect { subject.validate_checksum!("0123456789abcdef", checksum_type) }.to raise_error(Ddr::Models::ChecksumInvalid)
            end
          end
        end
      end
    end

    describe "extensions for external datastreams" do
      subject { described_class.new(nil, nil, controlGroup: "E") }

      describe "#file_path" do
        it "should return nil when dsLocation is not set" do
          expect(subject.file_path).to be_nil
        end
        it "should return nil when dsLocation is not a file URI" do
          subject.dsLocation = "http://library.duke.edu/"
          expect(subject.file_path).to be_nil
        end
        it "should return the file path when dsLocation is a file URI" do
          subject.dsLocation = "file:/tmp/foo/bar.txt"
          expect(subject.file_path).to eq "/tmp/foo/bar.txt"
        end
      end

      describe "#file_name" do
        it "should return nil when dsLocation is not set" do
          expect(subject.file_name).to be_nil
        end
        it "should return nil when dsLocation is not a file URI" do
          subject.dsLocation = "http://library.duke.edu/"
          expect(subject.file_name).to be_nil
        end
        it "should return the file name when dsLocation is a file URI" do
          subject.dsLocation = "file:/tmp/foo/bar.txt"
          expect(subject.file_name).to eq "bar.txt"
        end
      end

      describe "#file_size" do
        it "should return nil when dsLocation is not set" do
          expect(subject.file_size).to be_nil
        end
        it "should return nil when dsLocation is not a file URI" do
          subject.dsLocation = "http://library.duke.edu/"
          expect(subject.file_size).to be_nil
        end
        it "should return the file name when dsLocation is a file URI" do
          allow(File).to receive(:size).with("/tmp/foo/bar.txt") { 42 }
          subject.dsLocation = "file:/tmp/foo/bar.txt"
          expect(subject.file_size).to eq 42
        end
      end

    end # external datastreams

    describe "notifications" do
      let(:events) { [] }
      before {
        @subscriber = ActiveSupport::Notifications.subscribe(event_name) do |name, start, finish, id, payload|
          events << payload
        end
      }
      after {
        ActiveSupport::Notifications.unsubscribe(@subscriber)
      }
      describe "on create" do
        let(:obj) { ActiveFedora::Base.create }
        let(:event_name) { "create.DS1.datastream" }
        specify {
          obj.add_file_datastream("foo", dsid: "DS1", controlGroup: "M")
          obj.save!
          expect(events.first[:pid]).to eq obj.pid
          expect(events.first[:event_date_time]).to eq obj.datastreams["DS1"].createDate
        }
      end
      describe "on update" do
        let(:obj) { FactoryGirl.create(:item) }
        let(:event_name) { "update.descMetadata.datastream" }
        specify {
          obj.title = [ "Changed Title" ]
          obj.save!
          expect(events.first[:pid]).to eq obj.pid
          expect(events.first[:event_date_time]).to eq obj.descMetadata.createDate
        }
      end
      describe "on destroy" do
        let(:obj) { FactoryGirl.create(:item) }
        let(:event_name) { "delete.descMetadata.datastream" }
        specify {
          obj.descMetadata.delete
          expect(events.first[:pid]).to eq obj.pid
        }
      end
    end

  end
end
