module Ddr::Models
  RSpec.describe HasMultiresImage do

    subject { FactoryGirl.create(:component) }

    describe "cleaning up multires image file after destroy" do
      before {
        @file = Tempfile.create('foo')
        @path = @file.path
      }
      after {
        File.unlink(@path) if File.exist?(@path)
      }
      it "deletes the file" do
        subject.multires_image_file_path = "file:#{@path}"
        subject.save!
        subject.destroy
        expect(File.exist?(@path)).to be false
      end
    end

  end
end
