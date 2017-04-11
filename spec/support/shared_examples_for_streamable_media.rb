RSpec.shared_examples "an object that cannot be streamable" do
  it { is_expected.to_not be_streamable }
  its(:can_be_streamable?) { is_expected.to be false }
end

RSpec.shared_examples "an object that can be streamable" do
  it { is_expected.to_not be_streamable }
  its(:can_be_streamable?) { is_expected.to be true }

  describe "when streamable media is present" do
    before {
      subject.add_file(fixture_file_upload('bird.jpg', 'image/jpeg'), 'streamableMedia')
      subject.save!
    }
    specify {
      expect(subject).to be_streamable
      expect(subject.streamable_media_type).to eq 'image/jpeg'
      expect(subject.streamable_media_path).to be_present
      expect(subject.streamable_media_path).to eq subject.streamableMedia.file_path
    }
  end
end
