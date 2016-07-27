RSpec.describe ActiveFedora::File do
  describe "after_save" do
    let(:callback) {
      proc { |*args| nil }
    }
    around(:example) do |example|
      ActiveSupport::Notifications.subscribed(callback, Ddr::Notifications::FILE_SAVE) do
        example.run
      end
    end
    it "sends a notification" do
      expect(callback).to receive(:call).once
      file = described_class.new
      file.content = "foo"
      file.save
      file.save
    end
  end
end
