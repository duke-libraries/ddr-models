module Ddr::Models::Structures
  RSpec.describe ComponentTypeTerm do

    it "should return the correct term" do
      expect(described_class.term('image/tiff')).to eq("Images")
      expect(described_class.term('audio/x-wav')).to eq("Media")
      expect(described_class.term('video/quicktime')).to eq("Media")
      expect(described_class.term('text/plain')).to eq("Documents")
      expect(described_class.term('application/pdf')).to eq("Documents")
      expect(described_class.term('application/vnd.openxmlformats-officedocument.wordprocessingml.document')).to eq("Documents")
      expect(described_class.term('application/vnd.ms-access')).to be nil
    end
  end
end
