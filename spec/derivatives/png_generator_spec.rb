require 'spec_helper'

module Ddr::Derivatives
  RSpec.describe PngGenerator do

    describe "generate" do
      let(:tempdir) { Dir.mktmpdir }
      let(:output_path) { File.join(tempdir, "output.png") }
      let(:options) { "-resize '100x100>'" }
      let(:generator) { described_class.new(options) }
      after { FileUtils.rmdir(tempdir) }
      context "tiff source" do
        let(:source_path) { File.join(Ddr::Models::Engine.root, "spec", "fixtures", "imageA.tif") }
        it "should generate a non-empty file" do
          generator.generate(source_path, output_path)
          expect(File.size(output_path)).to be > 0
        end
        context "animated gif source" do
          let(:source) { File.join(Ddr::Models::Engine.root, "spec", "fixtures", "arrow1rightred_e0.gif") }
          it "should generate a non-empty file" do
            generator.generate
            expect(File.size(output_file.path)).to be > 0
          end
        end
      end
    end

  end
end