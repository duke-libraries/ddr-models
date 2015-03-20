require 'spec_helper'
require 'openssl'

RSpec.shared_examples "an object that can have content" do

  let(:object) { described_class.new(title: [ "I Have Content!" ]) }

  it "should delegate :validate_checksum! to :content" do
    checksum = "dea56f15b309e47b74fa24797f85245dda0ca3d274644a96804438bbd659555a"
    expect(object.content).to receive(:validate_checksum!).with(checksum, "SHA-256")
    object.validate_checksum!(checksum, "SHA-256")
  end

  describe "indexing" do
    let(:file) { fixture_file_upload("library-devil.tiff", "image/tiff") }
    before { object.upload file }
    it "should index the content ds control group" do
      expect(object.to_solr).to include(Ddr::IndexFields::CONTENT_CONTROL_GROUP)
    end
  end

  describe "adding a file" do
    let(:file) { fixture_file_upload("library-devil.tiff", "image/tiff") }
    context "defaults" do
      before { object.add_file file, "content" }
      it "should have an original_filename" do
        expect(object.original_filename).to eq("library-devil.tiff")
      end
      it "should have a content_type" do
        expect(object.content_type).to eq("image/tiff")
      end
      it "should create a 'virus check' event for the object" do
        expect { object.save }.to change { object.virus_checks.count }
      end
    end
    context "with option `:original_name=>false`" do
      before { object.add_file file, "content", original_name: false }
      it "should not have an original_filename" do
        expect(object.original_filename).to be_nil
      end
    end
    context "with `:original_name` option set to a string" do
      before { object.add_file file, "content", original_name: "another-name.tiff" }
      it "should have an original_filename" do
        expect(object.original_filename).to eq("another-name.tiff")
      end
    end
  end

  describe "save" do

    describe "when new content is present" do

      context "and it's a new object" do
        before { object.add_file file, "content" }
        let(:file) { fixture_file_upload("library-devil.tiff", "image/tiff") }
        it "should generate derivatives" do
          expect(object.derivatives).to receive(:update_derivatives)
          object.save
        end
      end

      context "and it's an existing object with content" do
        before { object.upload! fixture_file_upload('library-devil.tiff', 'image/tiff') }
        let(:file) { fixture_file_upload("image1.tiff", "image/tiff") }
        it "should generate derivatives" do
          expect(object.derivatives).to receive(:update_derivatives)
          object.upload! file
        end
      end
    end
  end

  describe "#upload" do
    let(:file) { fixture_file_upload("library-devil.tiff", "image/tiff") }
    it "should add the file to the content datastream" do
      expect(object).to receive(:add_file).with(file, "content", {})
      object.upload(file)
    end
  end

  describe "#upload!" do 
    let(:file) { fixture_file_upload("library-devil.tiff", "image/tiff") }
    it "should add the file to the content datastream and save the object" do
      expect(object).to receive(:add_file).with(file, "content", {}).and_call_original
      expect(object).to receive(:save)
      object.upload!(file)
    end
  end

end
