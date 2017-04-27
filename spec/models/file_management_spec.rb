RSpec.shared_examples "a repository external file" do
  it "is owned by the effective user" do
    expect(File.owned?(file_path)).to be true
  end
  it "is readable by the effective user" do
    expect(File.readable?(file_path)).to be true
  end
  it "is writable by the effective user" do
    expect(File.writable?(file_path)).to be true
  end
  it "does not have the sticky bit set" do
    expect(File.sticky?(file_path)).to be false
  end
  it "has 644 mode" do
    expect("%o" % File.world_readable?(file_path)).to eq "644"
  end
end

module Ddr::Models
  RSpec.describe FileManagement, :type => :model do

    let(:object) { Component.new }
    let(:image_file) { fixture_file_upload("imageA.tif", "image/tiff") }
    let(:xml_file)   { fixture_file_upload("fits/image.xml", "text/xml") }

    describe "#add_file" do
      it "runs a virus scan on the file" do
        expect(object).to receive(:virus_scan)
        object.add_file image_file, "content"
      end
      it "calls add_file_datastream by default" do
        expect(object).to receive(:add_file_datastream)
        object.add_file image_file, "random_ds_1"
      end
      it "calls add_file_datastream when dsid spec is managed" do
        expect(object).to receive(:add_file_datastream)
        object.add_file xml_file, "fits"
      end
      it "calls add_external_file when dsid spec is external" do
        expect(object).to receive(:add_external_file)
                           .with(image_file, "content", mime_type: "image/tiff")
        object.add_file image_file, "content"
      end
      it "calls add_external_file when :external => true option passed" do
        expect(object).to receive(:add_external_file)
                           .with(image_file, "random_ds_2", mime_type: "image/tiff")
        object.add_file image_file, "random_ds_2", external: true
      end
      context "original_filename" do
        context "when dsid == 'content'" do
          it "sets original_filename" do
            expect { object.add_file image_file, "content" }
              .to change(object, :original_filename).to("imageA.tif")
            expect { object.add_file image_file, "content", original_filename: "foo.tif" }
              .to change(object, :original_filename).to("foo.tif")
          end
        end
        context "when dsid != 'content'" do
          it "does not set original_filename" do
            expect { object.add_file xml_file, "fits" }
              .not_to change(object, :original_filename)
            expect { object.add_file xml_file, "fits", original_filename: "foo" }
              .not_to change(object, :original_filename)
          end
        end
      end
    end

    describe "#add_external_file" do
      it "calls add_external_datastream if no spec for dsid" do
        expect(object).to receive(:add_external_datastream).with("random_ds_3").and_call_original
        object.add_external_file(image_file, "random_ds_3")
      end
      it "raises an exception if datastream is not external" do
        expect { object.add_external_file(xml_file, "fits") }.to raise_error(ArgumentError)
      end
      it "sets the mimeType" do
        expect(object.content).to receive(:mimeType=).with("image/tiff")
        object.add_external_file(image_file, "content", mime_type: "image/tiff")
      end
      it "sets dsLocation to URI for generated file path by default" do
        object.add_external_file(image_file, "content")
        expect(object.content.dsLocation).not_to eq URI.escape("file:#{image_file.path}")
        expect(object.content.dsLocation).not_to be_nil
        expect(File.exists?(object.content.file_path)).to be true
      end
      context "external file permissions" do
        before { object.add_external_file(image_file, "content") }
        it_should_behave_like "a repository external file" do
          let(:file_path) {  object.content.file_path }
        end
      end
    end

    describe "#add_external_datastream" do
      it "returns a new external datastream" do
        ds = object.add_external_datastream("random_ds_27")
        expect(ds.controlGroup).to eq "E"
        expect(object.datastreams["random_ds_27"]).to eq ds
        expect(object.random_ds_27).to eq ds
      end
    end

    describe "#external_datastream_file_paths" do
      let(:file1) { fixture_file_upload("imageA.tif", "image/tiff") }
      let(:file2) { fixture_file_upload("imageC.tif", "image/tiff") }
      before do
        object.add_file(file1, "content")
        object.save
        object.add_file(file2, "e_content_2", external: true)
        object.save
      end
      it "returns a list of file paths for all versions of all external datastreams for the object" do
        paths = object.external_datastream_file_paths
        expect(paths.size).to eq 2
        paths.each do |path|
          expect(File.exists?(path)).to be true
        end
      end
    end

  end
end
