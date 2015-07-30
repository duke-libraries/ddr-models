require 'spec_helper'

module Ddr::Jobs
  RSpec.describe FitsFileCharacterization, jobs: true, file_characterization: true do

    shared_examples "has a fits update event" do
      let(:event) { object.update_events.last }
      it "should have the correct event attributes" do
        expect(event.outcome).to eq(expected_outcome)
        expect(event.detail).to eq(stderr_msg)
        expect(event.software).to eq("fits #{fits_version}")
      end
    end

    context "content-bearing object" do
      let(:object) { TestContent.create }
      let(:stdout_msg) { '<fits />' }
      let(:stderr_msg) { 'stderr msg' }
      let(:fits_version) { '0.9.9 '}
      before { allow(Ddr::Jobs::FitsFileCharacterization).to receive(:fits_version) { fits_version } }
      context "fits command is successful" do
        let(:expected_outcome) { Ddr::Events::Event::SUCCESS }
        before do
          allow(Open3).to receive(:capture3) { [ stdout_msg, stderr_msg,  $? ] }
          allow_any_instance_of(Process::Status).to receive(:success?) { true }
          Ddr::Jobs::FitsFileCharacterization.perform(object.pid)
          object.reload
        end
        it "should populate the fits datastream" do
          expect(object.fits.content).to be_present
        end
        it_behaves_like "has a fits update event"
      end
      context "fits command is not successful" do
        let(:expected_outcome) { Ddr::Events::Event::FAILURE }
        before do
          allow(Open3).to receive(:capture3) { [ stdout_msg, stderr_msg,  $? ] }
          allow_any_instance_of(Process::Status).to receive(:success?) { false }
          Ddr::Jobs::FitsFileCharacterization.perform(object.pid)
          object.reload
        end
        it "should not populate the fits datastream" do
          expect(object.fits.content).to_not be_present
        end
        it_behaves_like "has a fits update event"
      end
    end

  end
end