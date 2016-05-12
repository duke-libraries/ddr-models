require 'spec_helper'

module Ddr::Derivatives
  RSpec.describe Thumbnail do

    subject { described_class }

    let(:object) { Component.new }

    describe '.generatable?' do
      context 'object does not have content' do
        it "should not be generatable" do
          expect(subject.generatable?(object)).to be_falsey
        end
      end
      context 'object has content' do
        before { allow(object).to receive(:has_content?) { true } }
        context 'content is an image' do
          before { allow(object).to receive(:image?) { true } }
          it "should be generatable" do
            expect(subject.generatable?(object)).to be_truthy
          end
        end
        context 'content is not an image' do
          before { allow(object).to receive(:image?) { false } }
          it "should not be generatable" do
            expect(subject.generatable?(object)).to be_falsey
          end
        end
      end
    end

    describe '.has_derivative?' do
      context 'does not have thumbnail' do
        it 'should not have the derivative' do
          expect(subject.has_derivative?(object)).to be_falsey
        end
      end
      context 'has thumbnail' do
        before { allow(object).to receive(:has_thumbnail?) { true } }
        it 'should have the derivative' do
          expect(subject.has_derivative?(object)).to be_truthy
        end
      end
    end

  end
end