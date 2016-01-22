RSpec.shared_examples "a governable object" do
  let(:object) do
    described_class.new.tap do |obj|
      obj.desc_metadata.title = [ 'Describable' ]
      obj.desc_metadata.identifier = [ 'id001' ]
      obj.save(validate: false)
    end
  end
  describe "can have an admin policy" do
    let(:coll) { FactoryGirl.create(:collection) }
    it "should set its admin policy with #admin_policy= and get with #admin_policy" do
      object.admin_policy = coll
      object.save(validate: false)
      expect(ActiveFedora::Base.find(object.id).admin_policy).to eq(coll)
    end
  end
end
