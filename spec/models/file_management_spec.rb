require 'spec_helper'

RSpec.shared_examples "a repository external file" do
  it "should be owned by the effective user" do
    expect(File.owned?(file_path)).to be true
  end
  it "should be readable by the effective user" do
    expect(File.readable?(file_path)).to be true
  end
  it "should be writable by the effective user" do
    expect(File.writable?(file_path)).to be true
  end
  it "should not have the sticky bit set" do
    expect(File.sticky?(file_path)).to be false
  end
  it "should have 644 mode" do
    expect("%o" % File.world_readable?(file_path)).to eq "644"
  end
end

module Ddr
  module Models
    RSpec.describe FileManagement, :type => :model do

      let(:object) { FileManageable.new(pid: 'test:543') }
      let(:file) { fixture_file_upload("imageA.tif", "image/tiff") }

      before(:all) do
        class FileManageable < ActiveFedora::Base
          include Ddr::Models::FileManagement
          has_file_datastream name: "e_content", control_group: "E"
          has_file_datastream name: "m_content", control_group: "M"
          def original_filename
            'image001.tiff'
          end
        end
      end

      describe "#add_file" do
        it "should run a virus scan on the file" do
          expect(object).to receive(:virus_scan)
          object.add_file file, "m_content"
        end
        it "should call add_file_datastream by default" do
          expect(object).to receive(:add_file_datastream)
          object.add_file file, "random_ds_1"
        end
        it "should call add_file_datastream when dsid spec is managed" do
          expect(object).to receive(:add_file_datastream)
          object.add_file file, "m_content"
        end
        it "should call add_external_file when dsid spec is external" do
          expect(object).to receive(:add_external_file).with(file, "e_content", {mime_type: file.content_type})
          object.add_file file, "e_content"
        end
        it "should call add_external_file when :external => true option passed" do
          expect(object).to receive(:add_external_file).with(file, "random_ds_2", {mime_type: file.content_type})
          object.add_file file, "random_ds_2", external: true
        end
      end

      describe "#add_external_file" do
        it "should call add_external_datastream if no spec for dsid" do
          expect(object).to receive(:add_external_datastream).with("random_ds_3").and_call_original
          object.add_external_file(file, "random_ds_3")
        end
        it "should raise an error if datastream is not external" do
          expect { object.add_external_file(file, "m_content") }.to raise_error(ArgumentError)
        end
        it "should raise an error if dsLocation has changed" do
          allow(object.e_content).to receive(:dsLocation_changed?) { true }
          expect { object.add_external_file(file, "e_content") }.to raise_error(Error)
        end
        it "should set the mimeType" do
          expect(object.e_content).to receive(:mimeType=).with("image/tiff")
          object.add_external_file(file, "e_content")
        end
        context "storage path generation" do
          it "should generate a UUID for the file path" do
            expect(SecureRandom).to receive(:uuid).and_call_original
            object.add_external_file(file, "e_content")
          end
          it "should add a subpath using the configured pattern" do
            allow(SecureRandom).to receive(:uuid) { 'ebe837db-1d50-4e4f-a242-16c29f331023' }
            object.add_external_file(file, "e_content")
            path = object.e_content.file_path
            subpath = File.dirname(path.sub(Ddr::Models.external_file_store, "").sub("/", ""))
            expect(subpath).to eq 'eb/ebe837db-1d50-4e4f-a242-16c29f331023'
          end
          describe "external file name" do
            context "datastream without designated file name extension" do
              context "original file name present" do
                it "should set the file name to the original file name" do
                  object.add_external_file(file, "e_content")
                  expect(object.e_content.file_name).to eq object.original_filename
                end
              end
              context "original file name not present" do
                before { allow(object).to receive(:original_filename) { nil } }
                it "should set the file name to the datastream default file name" do
                  object.add_external_file(file, "e_content")
                  expect(object.e_content.file_name).to eq object.e_content.default_file_name
                end
              end
            end
            context "multiresImage datastream" do
              context "original file name present" do
                it "should set the file name to the original file name with the designated extension" do
                  object.add_external_file(file, Ddr::Datastreams::MULTIRES_IMAGE, mime_type: "image/tiff")
                  expect(object.datastreams[Ddr::Datastreams::MULTIRES_IMAGE].file_name).to eq 'image001.ptif'
                end
              end
              context "original file name not present" do
                let(:expected_file_name) do
                  default_fn = object.datastreams[Ddr::Datastreams::MULTIRES_IMAGE].default_file_name
                  "#{File.basename(default_fn, File.extname(default_fn))}.ptif"
                end
                before { allow(object).to receive(:original_filename) { nil } }
                it "should set the file name to the datastream default file name with the designated extension" do
                  object.add_external_file(file, Ddr::Datastreams::MULTIRES_IMAGE)
                  expect(object.datastreams[Ddr::Datastreams::MULTIRES_IMAGE].file_name).to eq expected_file_name
                end
              end
            end
          end
          describe "external file store base directory" do
            describe "datastream with default base directory" do
              it "should prepend the configured external file store base directory" do
                object.add_external_file(file, "e_content")
                expect(object.e_content.file_path.start_with?(Ddr::Models.external_file_store)).to be true
              end
            end
            describe "datastream with default multires image base directory" do
              it "should prepend the configured multires image external file store base directory" do
                object.add_external_file(file, Ddr::Datastreams::MULTIRES_IMAGE)
                expect(object.datastreams[Ddr::Datastreams::MULTIRES_IMAGE].file_path.start_with?(Ddr::Models.multires_image_external_file_store)).to be true
              end
            end
          end
        end
        it "should set dsLocation to URI for generated file path by default" do
          object.add_external_file(file, "e_content")
          expect(object.e_content.dsLocation).not_to eq URI.escape("file:#{file.path}")
          expect(object.e_content.dsLocation).not_to be_nil
          expect(File.exists?(object.e_content.file_path)).to be true
        end
        it "should set dsLocation to URI for original file path if :use_original => true option" do
          expect(object.e_content).to receive(:dsLocation=).with(URI.escape("file:#{file.path}"))
          object.add_external_file(file, "e_content", use_original: true)
        end
        it "should raise an error if using original file not owned by effective user" do
          allow(File).to receive(:owned?).with(file.path) { false }
          expect { object.add_external_file(file, "e_content", use_original: true) }.to raise_error(Error)
        end
        context "external file permissions" do
          context "for a generated file" do
            before { object.add_external_file(file, "e_content") }
            it_should_behave_like "a repository external file" do
              let(:file_path) {  object.e_content.file_path }
            end
          end
          context "for an original file" do
            before { object.add_external_file(file, "e_content", use_original: true) }
            it_should_behave_like "a repository external file" do
              let(:file_path) {  object.e_content.file_path }
            end
          end
        end
      end

      describe "#add_external_datastream" do
        it "should return a new external datastream" do
          ds = object.add_external_datastream("random_ds_27")
          expect(ds.controlGroup).to eq "E"
          expect(object.datastreams["random_ds_27"]).to eq ds
          expect(object.random_ds_27).to eq ds
        end
      end

      describe "#external_datastream_file_paths" do
        let(:file1) { fixture_file_upload("imageA.tif", "image/tiff") }
        let(:file2) { fixture_file_upload("imageB.tif", "image/tiff") }
        let(:file3) { fixture_file_upload("imageC.tif", "image/tiff") }
        before do
          object.add_file(file1, "e_content")
          object.save
          object.add_file(file2, "e_content")
          object.save
          object.add_file(file3, "e_content_2", external: true)
          object.save
        end
        it "should return a list of file paths for all versions of all external datastreams for the object" do
          paths = object.external_datastream_file_paths
          expect(paths.size).to eq 3
          paths.each do |path|
            expect(File.exists?(path)).to be true
          end
        end
      end

      describe "cleanup on destroy" do
        let(:file1) { fixture_file_upload("imageA.tif", "image/tiff") }
        let(:file2) { fixture_file_upload("imageB.tif", "image/tiff") }
        let(:file3) { fixture_file_upload("imageC.tif", "image/tiff") }
        before do
          object.add_file(file1, "e_content")
          object.save
          object.add_file(file2, "e_content")
          object.save
          object.add_file(file3, "e_content_2", external: true)
          object.save
        end
        it "should delete all files for all versions of all external datastreams" do
          expect(File).to receive(:unlink).with(*object.external_datastream_file_paths)
          object.destroy
        end
      end

    end
  end
end
