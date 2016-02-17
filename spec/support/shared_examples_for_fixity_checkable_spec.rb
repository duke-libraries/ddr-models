RSpec.shared_examples "a fixity checkable object" do

  describe "fixity check" do
    before do
      subject.thumbnail.content = '1234567890'
      subject.save(validate: false)
    end
    it "can check fixity" do
      expect { subject.check_fixity }.to change(subject.fixity_checks, :count).from(0).to(1)
    end
  end

end
