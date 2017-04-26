RSpec.describe ActiveFedora::Base do

  before { allow(Ddr::Models::AdminSet).to receive(:find_by_code) { test_admin_set } }

  describe ".find" do
    let!(:collection) { FactoryGirl.create(:collection) }
    describe "when called on the wrong class" do
      it "should raise an exception" do
        expect { Item.find(collection.pid) }.to raise_error(Ddr::Models::ContentModelError)
      end
    end
    describe "when called on Ddr::Models::Base" do
      it "should cast to the object's class" do
        expect(Ddr::Models::Base.find(collection.pid)).to eq(collection)
      end
    end
    describe "when called on ActiveFedora::Base" do
      it "should cast to the object's class" do
        expect(ActiveFedora::Base.find(collection.pid)).to eq(collection)
      end
    end
    describe "when called on the object's class" do
      it "should return the object" do
        expect(Collection.find(collection.pid)).to eq(collection)
      end
    end
  end

  its(:can_be_streamable?) { is_expected.to be false }
  it { is_expected.not_to be_streamable }

end
