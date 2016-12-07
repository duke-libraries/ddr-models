require 'spec_helper'

RSpec.describe Component, type: :model, components: true do

  it_behaves_like "a DDR model"
  it_behaves_like "an object that can have content"
  it_behaves_like "it has an association", :belongs_to, :parent, :is_part_of, "Item"
  it_behaves_like "it has an association", :belongs_to, :target, :has_external_target, "Target"
  it_behaves_like "a non-collection model"
  it_behaves_like "a potentially publishable object"

  describe "indexing" do
    subject { FactoryGirl.build(:component) }
    before do
      allow(subject).to receive(:collection) { Collection.new(pid: "test:1") }
    end
    its(:index_fields) { is_expected.to include(Ddr::Index::Fields::COLLECTION_URI => "info:fedora/test:1") }
  end

  shared_examples "default datastream use" do
    it "associates the correct datastream with the correct use" do
      expect(file.use).to eq(use)
      expect(flocat.href).to eq(ds)
      expect(fptr.fileid).to eq(file.id)
    end
  end

  describe "default structure" do
    describe "no content" do
      it "should be nil" do
        expect(subject.default_structure).to be_nil
      end
    end
    describe "content" do
      let(:struct) { subject.default_structure }
      let(:flocat) { file.flocats.first }
      before { allow(subject).to receive(:has_content?) { true } }
      describe "with multires image" do
        before do
          allow(subject).to receive(:has_multires_image?) { true }
        end
        describe "master" do
          let(:file) { struct.filesec.filegrps.first.files.first }
          let(:fptr) { struct.structmap.divs.first.fptrs.first }
          let(:use) { Ddr::Models::Structure::USE_MASTER }
          let(:ds) { Ddr::Datastreams::CONTENT }
          it_behaves_like "default datastream use"
        end
        describe "imageserver" do
          let(:file) { struct.filesec.filegrps.first.files.second }
          let(:fptr) { struct.structmap.divs.first.fptrs.second }
          let(:use) { Ddr::Models::Structure::USE_IMAGESERVER }
          let(:ds) { Ddr::Datastreams::MULTIRES_IMAGE }
          it_behaves_like "default datastream use"
        end
      end
      describe "without multires image" do
        describe "master" do
          let(:file) { struct.filesec.filegrps.first.files.first }
          let(:fptr) { struct.structmap.divs.first.fptrs.first }
          let(:use) { Ddr::Models::Structure::USE_MASTER }
          let(:ds) { Ddr::Datastreams::CONTENT }
          it_behaves_like "default datastream use"
        end
        describe "access" do
          let(:file) { struct.filesec.filegrps.first.files.second }
          let(:fptr) { struct.structmap.divs.first.fptrs.second }
          let(:use) { Ddr::Models::Structure::USE_ACCESS }
          let(:ds) { Ddr::Datastreams::CONTENT }
          it_behaves_like "default datastream use"
        end
      end
      describe "thumbnail" do
        let(:file) { struct.filesec.filegrps.first.files.third }
        let(:fptr) { struct.structmap.divs.first.fptrs.third }
        let(:use) { Ddr::Models::Structure::USE_THUMBNAIL }
        let(:ds) { Ddr::Datastreams::THUMBNAIL }
        before { allow(subject).to receive(:has_thumbnail?) { true } }
        it_behaves_like "default datastream use"
      end
    end

  end
end
