module Ddr::Models
  RSpec.describe AttachedFilesProfile do

    subject { described_class.new(obj) }

    let(:obj) { FactoryGirl.create(:component) }
    let!(:json) {
      '{"content":{"size":230714,"mime_type":"image/tiff","sha1":"75e2e0cec6e807f6ae63610d46448f777591dd6b"}}'
    }

    its(:to_json) { is_expected.to eq(json) }

  end
end
