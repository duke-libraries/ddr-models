module Ddr::Models
  RSpec.describe WithContentFile do

    let(:obj) { FactoryGirl.create(:component) }

    before {
      obj.content.checksumType = "SHA-1"
      obj.save!
    }

    it "yields a temp file path to the block and deletes the temp file afterwards" do
      WithContentFile.new(obj) do |path|
        @path = path
        expect(File.exist?(path)).to be true
      end
      expect(File.exist?(@path)).to be false
    end

    it "deletes the temp file even when an exception is raised in the block" do
      begin
        WithContentFile.new(obj) do |path|
          @path = path
          expect(File.exist?(path)).to be true
          raise Error, "error"
        end
      rescue Error
        expect(File.exist?(@path)).to be false
      end
    end

    it "raises an exception when the checksum verification fails" do
      allow(obj.content).to receive(:checksum) { "foo" }
      expect { WithContentFile.new(obj) { |p| nil } }.to raise_error(ChecksumInvalid)
    end

  end
end
