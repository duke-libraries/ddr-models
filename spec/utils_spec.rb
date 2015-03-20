require 'spec_helper'

module Ddr
  RSpec.describe Utils do
    describe "sanitize filename" do
      it "should return nil if not given an argument" do
        expect(Ddr::Utils.sanitize_filename(nil)).to be_nil
      end
      it "should raise an exception if given a non-String argument" do
        expect { Ddr::Utils.sanitize_filename(File.new) }.to raise_error(ArgumentError)
      end
      it "should raise an exception if given a string with a path separator" do
        expect { Ddr::Utils.sanitize_filename(File.join('my', 'file.txt')) }.to raise_error(ArgumentError)
      end
      it "should return the unaltered file name if given a sanitary file name" do
        expect(Ddr::Utils.sanitize_filename(File.join('my-file01.txt'))).to eq('my-file01.txt')
      end
      it "should a sanitized file name if given an unsanitary file name" do
        expect(Ddr::Utils.sanitize_filename(File.join('my##file01$.txt%%'))).to eq('my__file01_.txt__')
      end
    end
  end
end