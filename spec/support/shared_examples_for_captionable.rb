RSpec.shared_examples "an object that cannot be captioned" do
  it { is_expected.to_not be_captioned }
  its(:captionable?) { is_expected.to be false }
end

RSpec.shared_examples "an object that can be captioned" do
  it { is_expected.to_not be_captioned }
  its(:captionable?) { is_expected.to be true }

  describe "when caption file is present" do
    before {
      subject.add_file(fixture_file_upload('abcd1234.vtt', 'text/vtt'), 'caption')
      subject.save!
    }
    specify {
      expect(subject).to be_captioned
      expect(subject.caption_path).to be_present
      expect(subject.caption_path).to eq subject.caption.file_path
      expect(subject.caption_type).to eq 'text/vtt'
      expect(subject.caption_extension).to eq 'vtt'
    }
  end
end
