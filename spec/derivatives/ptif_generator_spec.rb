module Ddr::Derivatives
  RSpec.describe PtifGenerator do

    describe "generate" do
      let(:tempdir) { Dir.mktmpdir }
      let(:output_file) { File.new(File.join(tempdir, "output.ptif"), 'wb') }
      let(:options) { "jpeg:90,tile:256x256,pyramid" }
      let(:generator) { described_class.new(source, output_file.path, options) }
      after { FileUtils.rmdir(tempdir) }
      context "tiff source" do
        context "8-bit source" do
          let(:source) { File.join(Ddr::Models::Engine.root, "spec", "fixtures", "8bit.tif") }
          it "should generate a non-empty file" do
            generator.generate
            expect(File.size(output_file.path)).to be > 0
          end
        end
        context "16-bit source" do
          let(:source) { File.join(Ddr::Models::Engine.root, "spec", "fixtures", "16bit.tif") }
          it "should generate a non-empty file" do
            generator.generate
            expect(File.size(output_file.path)).to be > 0
          end
        end
      end
    end

  end
end
