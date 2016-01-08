module Ddr::Models
  RSpec.describe FileCharacterization do

    subject { described_class.new(obj) }

    let(:obj) { FactoryGirl.create(:component) }
    let(:fits_output) { "<fits/>" }

    before {
      allow(subject).to receive(:with_content_file).and_yield("/tmp/foobar")
    }

    describe "when there is an error running FITS" do
      before {
        allow(subject).to receive(:run_fits).with("/tmp/foobar").and_raise(FileCharacterization::FITSError)
      }
      specify {
        begin
          subject.call
        rescue FileCharacterization::FITSError
        ensure
          expect(subject.fits).not_to have_content
        end
      }
    end

    describe "when FITS runs successfully" do
      before {
        allow(subject).to receive(:run_fits).with("/tmp/foobar") { fits_output }
      }
      specify {
        subject.call
        expect(subject.fits.content).to eq(fits_output)
      }
    end

  end
end
