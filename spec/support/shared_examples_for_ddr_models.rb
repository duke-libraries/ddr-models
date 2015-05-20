RSpec.shared_examples "a DDR model" do

  it_behaves_like "a describable object"
  it_behaves_like "a governable object"
  it_behaves_like "a licensable object"
  it_behaves_like "an access controllable object"
  it_behaves_like "an object that has properties"
  it_behaves_like "an object that has a display title"

  describe "events" do
    describe "on deletion with #destroy" do
      before { subject.save(validate: false) }
      it "should create a deletion event" do
        expect { subject.destroy }.to change { Ddr::Events::DeletionEvent.for_object(subject).count }.from(0).to(1)
      end
    end

    describe "last virus check" do
      let!(:fixity_check) { Ddr::Events::FixityCheckEvent.new }
      before { allow(subject).to receive(:last_fixity_check) { fixity_check } }
      its(:last_fixity_check_on) { should eq(fixity_check.event_date_time) }
      its(:last_fixity_check_outcome) { should eq(fixity_check.outcome) }
    end
  end

end
