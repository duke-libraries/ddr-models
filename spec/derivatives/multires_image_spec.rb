require 'spec_helper'

module Ddr::Derivatives
  RSpec.describe MultiresImage do

    subject { described_class }

    let(:object) { Component.new }

    describe '#generatable?' do
      context 'object does not have content' do
        it "should not be generatable" do
          expect(subject.generatable?(object)).to be_falsey
        end
      end
      context 'object has content' do
        before { allow(object).to receive(:has_content?) { true } }
        context 'content is a tiff image' do
          before { allow(object).to receive(:content_type) { 'image/tiff' } }
          it "should be generatable" do
            expect(subject.generatable?(object)).to be_truthy
          end
        end
        context 'content is not a tiff image' do
          before { allow(object).to receive(:content_type) { 'image/jpeg' } }
          it "should not be generatable" do
            expect(subject.generatable?(object)).to be_falsey
          end
        end
      end

      describe '.has_derivative?' do
        context 'does not have multires image' do
          it 'should not have the derivative' do
            expect(subject.has_derivative?(object)).to be_falsey
          end
        end
        context 'has multires image' do
          before { allow(object).to receive(:multires_image_file_path) { '/tmp/foo.ptif' } }
          it 'should have the derivative' do
            expect(subject.has_derivative?(object)).to be_truthy
          end
        end
      end

    end
  end
end