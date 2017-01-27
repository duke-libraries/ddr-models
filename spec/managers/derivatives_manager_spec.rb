module Ddr::Managers
  RSpec.describe DerivativesManager do

    before(:all) do
      class ContentBearing < ActiveFedora::Base
        include Ddr::Models::HasAdminMetadata
        include Ddr::Models::HasContent
        include Ddr::Models::HasMezzanine
        include Ddr::Models::HasThumbnail
        include Ddr::Models::EventLoggable
        _save_callbacks.clear
      end
      class MultiresImageable < ContentBearing
        include Ddr::Models::HasMultiresImage
        _save_callbacks.clear
      end
    end

    after(:all) do
      Ddr::Managers.send(:remove_const, :MultiresImageable)
      Ddr::Managers.send(:remove_const, :ContentBearing)
    end

    describe "generators called" do
      before { object.add_file file, Ddr::Datastreams::CONTENT }
      context "all derivatives" do
        context "not multires_image_able" do
          let(:object) { ContentBearing.new }
          context "content is an image" do
            let(:file) { fixture_file_upload("imageA.tif", "image/tiff") }
            it "calls the thumbnail generator and not the ptif generator" do
              expect(object.derivatives).to receive(:generate_derivative).with(Ddr::Derivatives::DERIVATIVES[:thumbnail])
              expect(object.derivatives).to_not receive(:generate_derivative).with(Ddr::Derivatives::DERIVATIVES[:multires_image])
              object.derivatives.update_derivatives(:now)
            end
          end
          context "content is not an image" do
            let(:file) { fixture_file_upload("sample.docx", "application/vnd.openxmlformats-officedocument.wordprocessingml.document") }
            it "should generate neither a thumbnail nor a ptif" do
              expect(object.derivatives).to_not receive(:generate_derivative).with(Ddr::Derivatives::DERIVATIVES[:thumbnail])
              expect(object.derivatives).to_not receive(:generate_derivative).with(Ddr::Derivatives::DERIVATIVES[:multires_image])
              object.derivatives.update_derivatives(:now)
            end
          end
        end
        context "multires_image_able" do
          let(:object) { MultiresImageable.new }
          context "content is tiff image" do
            let(:file) { fixture_file_upload("imageA.tif", "image/tiff") }
            it "should generate a thumbnail and a ptif" do
              expect(object.derivatives).to receive(:generate_derivative).with(Ddr::Derivatives::DERIVATIVES[:thumbnail])
              expect(object.derivatives).to receive(:generate_derivative).with(Ddr::Derivatives::DERIVATIVES[:multires_image])
              object.derivatives.update_derivatives(:now)
            end
          end
          context "content is not tiff image" do
            let(:file) { fixture_file_upload("bird.jpg", "image/jpeg") }
            it "should generate a thumbnail and a ptif" do
              expect(object.derivatives).to receive(:generate_derivative).with(Ddr::Derivatives::DERIVATIVES[:thumbnail])
              expect(object.derivatives).to receive(:generate_derivative).with(Ddr::Derivatives::DERIVATIVES[:multires_image])
              object.derivatives.update_derivatives(:now)
            end
          end
          context "content is not tiff or jpeg image" do
            let(:file) { fixture_file_upload("arrow1rightred_e0.gif", "image/gif") }
            it "should generate a thumbnail but not a ptif" do
              expect(object.derivatives).to receive(:generate_derivative).with(Ddr::Derivatives::DERIVATIVES[:thumbnail])
              expect(object.derivatives).to_not receive(:generate_derivative).with(Ddr::Derivatives::DERIVATIVES[:multires_image])
              object.derivatives.update_derivatives(:now)
            end
          end
        end
      end
      context "not all derivatives" do
        let!(:derivs) { Ddr::Derivatives.update_derivatives }
        before { Ddr::Derivatives.update_derivatives = [ :thumbnail ] }
        after { Ddr::Derivatives.update_derivatives = derivs }
        let(:object) { MultiresImageable.new }
        let(:file) { fixture_file_upload("imageA.tif", "image/tiff") }
        it "should only generate the thumbnail derivative" do
          expect(object.derivatives).to receive(:generate_derivative).with(Ddr::Derivatives::DERIVATIVES[:thumbnail])
          expect(object.derivatives).to_not receive(:generate_derivative).with(Ddr::Derivatives::DERIVATIVES[:multires_image])
          object.derivatives.update_derivatives(:now)
        end
      end
    end

    describe "derivative generation" do
      let(:file) { fixture_file_upload("imageA.tif", "image/tiff") }
      before { object.upload! file }
      describe "thumbnail" do
        let(:object) { ContentBearing.create }
        it "should create content in the thumbnail datastream" do
          expect(object.datastreams[Ddr::Datastreams::THUMBNAIL]).to_not be_present
          object.derivatives.generate_derivative! Ddr::Derivatives::DERIVATIVES[:thumbnail]
          expect(object.datastreams[Ddr::Datastreams::THUMBNAIL]).to be_present
          expect(object.datastreams[Ddr::Datastreams::THUMBNAIL].size).to be > 0
        end
      end
      describe "ptif" do
        let(:object) { MultiresImageable.create }
        it "should create content in the multires image datastream" do
          expect(object.datastreams[Ddr::Datastreams::MULTIRES_IMAGE]).to_not be_present
          object.derivatives.generate_derivative! Ddr::Derivatives::DERIVATIVES[:multires_image]
          expect(object.datastreams[Ddr::Datastreams::MULTIRES_IMAGE]).to be_present
          file_uri = object.datastreams[Ddr::Datastreams::MULTIRES_IMAGE].dsLocation
          expect(File.size(Ddr::Utils.path_from_uri(file_uri))).to be > 0
        end
      end
    end

    describe "mezzanine handling" do
      let(:object) { MultiresImageable.create }
      let(:file) { fixture_file_upload("imageA.tif", "image/tiff") }
      before { object.upload! file }
      describe "object has mezzanine file" do
        let(:mezzanine) { fixture_file_upload("bird.jpg", "image/jpeg") }
        before do
          object.add_file mezzanine, Ddr::Datastreams::MEZZANINE
          object.save!
          object.reload
          expect(object.mezzanine).to receive(:content).and_call_original
          expect(object.content).to_not receive(:content)
        end
        it "uses the mezzanine file as the derivative source" do
          object.derivatives.generate_derivative! Ddr::Derivatives::DERIVATIVES[:multires_image]
        end
      end
      describe "object does not have mezzanine file" do
        before do
          expect(object.content).to receive(:content).and_call_original
        end
        it "uses the content file as the derivative source" do
          object.derivatives.generate_derivative! Ddr::Derivatives::DERIVATIVES[:multires_image]
        end
      end
    end

    describe "exception during derivative generation" do
      let(:object) { ContentBearing.create }
      before do
        allow(Dir::Tmpname).to receive(:make_tmpname).with('', nil) { 'test-temp-dir' }
        # simulate raising of exception during derivative generation
        allow_any_instance_of(Ddr::Managers::DerivativesManager).to receive(:generate_derivative!).and_raise(StandardError)
      end
      it "should delete the temporary work directory" do
        expect(File.exist?(File.join(Dir.tmpdir, 'test-temp-dir'))).to be false
      end
    end

  end
end
