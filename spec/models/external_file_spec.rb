require 'spec_helper'

module Ddr::Models
  RSpec.describe ExternalFile do

    describe "#location=" do
      it "should set the location as a file URI" do
        subject.location = '/tmp/foo.txt'
        expect(subject.location).to eq('file:/tmp/foo.txt')
      end
    end

    describe "#file_path" do
      it "should return the location as a file path" do
        subject.location = '/tmp/foo.txt'
        expect(subject.file_path).to eq('/tmp/foo.txt')
      end
    end

    describe "callbacks" do
      describe "before save" do
        before { allow(File).to receive(:exists?).with('/tmp/foo.txt') { true } }
        context "mime type is provided" do
          it "should not change the provided mime type" do
            subject.location = '/tmp/foo.txt'
            subject.mime_type = 'image/jpeg'
            subject.save
            expect(subject.mime_type).to eq('image/jpeg')
          end
        end
        context "mime type is not provided" do
          it "should set the mime type" do
            subject.location = '/tmp/foo.txt'
            subject.save
            expect(subject.mime_type).to eq('text/plain')
          end
        end
      end
    end
  end
end