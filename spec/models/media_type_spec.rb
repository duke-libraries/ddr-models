module Ddr::Models
  RSpec.describe MediaType do

    subject { described_class.call(file) }

    describe "when a preferred media type is available" do
      describe "with a file path" do
        let(:file) { 'foo.mp4' }
        it { is_expected.to eq 'video/mp4' }
      end
      describe "with an object that responds to :path" do
        let(:file) { double(path: 'foo.mp4') }
        it { is_expected.to eq 'video/mp4' }
      end
    end
    describe "when a preferred media type is not available" do
      describe "and the file responds to :content_type" do
        let(:file) { double(path: 'foo.jpg', content_type: 'foo/bar') }
        it { is_expected.to eq 'foo/bar' }
      end
      describe "and the file does not respond to :content_type" do
        describe "and MIME types are present" do
          describe "with an object that responds to :path" do
            let(:file) { double(path: 'foo.jpg') }
            it { is_expected.to eq 'image/jpeg' }
          end
          describe "with a file path" do
            let(:file) { 'foo.jpg' }
            it { is_expected.to eq 'image/jpeg' }
          end
        end
        describe "and MIME types are not present" do
          describe "with an object that responds to :path" do
            let(:file) { double(path: 'foo.bar') }
            it { is_expected.to eq 'application/octet-stream' }
          end
          describe "with a file path" do
            let(:file) { 'foo.bar' }
            it { is_expected.to eq 'application/octet-stream' }
          end
        end
      end
    end

  end
end
