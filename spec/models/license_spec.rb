module Ddr::Models
  RSpec.describe License do

    describe ".call" do
      subject { described_class.call(obj) }

      describe "when the object has a license URL" do
        let(:url) { "http://example.com" }
        let(:obj) { double(pid: "test:1", license: url) }
        before do
          allow(described_class).to receive(:find).with(url: url) { described_class.new(url: url, title: "A License") }
        end
        its(:pid) { is_expected.to eq("test:1") }
        its(:to_s) { is_expected.to eq("A License") }
      end

      describe "when the object does not have a license" do
        let(:obj) { double(pid: "test:1", license: nil) }
        it { is_expected.to be_nil }
      end
    end

  end
end
