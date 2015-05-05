require 'spec_helper'

module Ddr
  module Managers
    RSpec.describe DerivativesManager do

      before(:all) do
        class ContentBearing < ActiveFedora::Base
          include Ddr::Models::HasAdminMetadata
          include Ddr::Models::HasContent
          include Ddr::Models::HasThumbnail
          include Ddr::Models::EventLoggable
          _save_callbacks.clear
        end
        # class MultiresImageable < ContentBearing
        #   include Ddr::Models::HasMultiresImage
        #   _save_callbacks.clear
        # end
      end

      after(:all) do
        # Ddr::Managers.send(:remove_const, :MultiresImageable)
        Ddr::Managers.send(:remove_const, :ContentBearing)
      end

      describe "generators called" do
        before { object.add_file file, Ddr::Datastreams::CONTENT }
        context "not multires_image_able" do
          let(:object) { ContentBearing.new }
          context "content is image" do
            let(:file) { fixture_file_upload("image1.tiff", "image/tiff") }
            it "should generate a thumbnail and not a ptif" do
              expect(object.derivatives).to receive(:generate_derivative!).with(Ddr::Derivatives::DERIVATIVES[:thumbnail])
              # expect(object.derivatives).to_not receive(:generate_derivative!).with(Ddr::Derivatives::DERIVATIVES[:multires_image])
              object.derivatives.update_derivatives(:now)
            end
          end
          context "content is a PDF" do
            let(:file) { fixture_file_upload("sample.pdf", "application/pdf") }
            it "should generate a thumbnail and not a ptif" do
              expect(object.derivatives).to receive(:generate_derivative!).with(Ddr::Derivatives::DERIVATIVES[:thumbnail])
              # expect(object.derivatives).to_not receive(:generate_derivative!).with(Ddr::Derivatives::DERIVATIVES[:multires_image])
              object.derivatives.update_derivatives(:now)
            end
          end
          context "content is neither an image nor a PDF" do
            let(:file) { fixture_file_upload("sample.docx", "application/vnd.openxmlformats-officedocument.wordprocessingml.document") }
            it "should generate neither a thumbnail nor a ptif" do
              expect(object.derivatives).to_not receive(:generate_derivative!).with(Ddr::Derivatives::DERIVATIVES[:thumbnail])
              # expect(object.derivatives).to_not receive(:generate_derivative!).with(Ddr::Derivatives::DERIVATIVES[:multires_image])
              object.derivatives.update_derivatives(:now)
            end
          end
        end
        # context "multires_image_able" do
        #   let(:object) { MultiresImageable.new }
        #   context "content is tiff image" do
        #     let(:file) { fixture_file_upload("image1.tiff", "image/tiff") }
        #     it "should generate a thumbnail and a ptif" do
        #       expect(object.derivatives).to receive(:generate_derivative!).with(Ddr::Derivatives::DERIVATIVES[:thumbnail])
        #       expect(object.derivatives).to receive(:generate_derivative!).with(Ddr::Derivatives::DERIVATIVES[:multires_image])
        #       object.derivatives.update_derivatives(:now)
        #     end
        #   end
        #   context "content is not tiff image" do
        #     let(:file) { fixture_file_upload("sample.pdf", "application/pdf") }
        #     it "should generate a thumbnail but not a ptif" do
        #       expect(object.derivatives).to receive(:generate_derivative!).with(Ddr::Derivatives::DERIVATIVES[:thumbnail])
        #       expect(object.derivatives).to_not receive(:generate_derivative!).with(Ddr::Derivatives::DERIVATIVES[:multires_image])
        #       object.derivatives.update_derivatives(:now)
        #     end
        #   end
        # end
      end

      describe "derivative generation" do
        let(:file) { fixture_file_upload("image1.tiff", "image/tiff") }
        before { object.upload! file }
        describe "thumbnail" do
          let(:object) { ContentBearing.create }
          it "should create content in the thumbnail datastream" do
            expect(object.datastreams[Ddr::Datastreams::THUMBNAIL]).to_not be_present
            object.derivatives.generate_derivative! Ddr::Derivatives::DERIVATIVES[:thumbnail]
            expect(object.datastreams[Ddr::Datastreams::THUMBNAIL]).to be_present
          end
        end
        # describe "ptif" do
        #   let(:object) { MultiresImageable.create }
        #   it "should create content in the multires image datastream" do
        #     expect(object.datastreams[Ddr::Datastreams::MULTIRES_IMAGE]).to_not be_present
        #     object.derivatives.generate_derivative! Ddr::Derivatives::DERIVATIVES[:multires_image]
        #     expect(object.datastreams[Ddr::Datastreams::MULTIRES_IMAGE]).to be_present
        #   end
        # end
      end

      describe "event creation" do
        let(:file) { fixture_file_upload("image1.tiff", "image/tiff") }
        before { object.upload! file }
        # let(:object) { MultiresImageable.create }
        let(:object) { ContentBearing.create }
        it "should create an update event for each derivative updated" do
          # expect {object.derivatives.update_derivatives(:now) }.to change { object.update_events.count }.by(2)
          expect {object.derivatives.update_derivatives(:now) }.to change { object.update_events.count }.by(1)
        end
      end

    end
  end
end
