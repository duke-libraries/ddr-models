RSpec.shared_examples "a fixity checkable object" do

  let(:object) { described_class.new }

  describe "fixity check" do
    before do
      object.thumbnail.content = '1234567890'
      object.save(validate: false)
    end
    it "should be able to perform a fixity check" do
      expect(Ddr::Actions::FixityCheck.execute(object)).to_not be_nil
    end
  end

end