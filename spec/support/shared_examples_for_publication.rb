RSpec.shared_examples 'a publishable object' do
  describe '#publishable?' do
    let(:object) { described_class.new }
    it 'should be publishable' do
      expect(object.publishable?).to be true
    end
  end
end

RSpec.shared_examples 'an unpublishable object' do
  describe '#publishable?' do
    let(:object) { described_class.new }
    it 'should not be publishable' do
      expect(object.publishable?).to be false
    end
  end
end

RSpec.shared_examples 'a potentially publishable object' do
  describe "#publishable?" do
    let(:object) { described_class.new }
    context "has parent" do
      before { allow(object).to receive(:parent) { parent } }
      context "parent is published" do
        let(:parent) { double(published?: true) }
        it "should be publishable" do
          expect(object.publishable?).to be true
        end
      end
      context "parent is not published" do
        let(:parent) { double(published?: false) }
        it "should not be publishable" do
          expect(object.publishable?).to be false
        end
      end
    end
    context "does not have parent" do
      it "should not be publishable" do
        expect(object.publishable?).to be false
      end
    end
  end
end
