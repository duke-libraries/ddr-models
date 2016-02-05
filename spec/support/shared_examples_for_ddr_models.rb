RSpec.shared_examples "a DDR model" do

  it_behaves_like "a describable object"
  it_behaves_like "a governable object"
  it_behaves_like "an object that has a display title"
  it_behaves_like "an object that has identifiers"
  it_behaves_like "a fixity checkable object"

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

  describe "versioning" do
    describe "on create" do
      it "creates a version" do
        expect { subject.save(validate: false) }
          .to change(subject, :has_versions?).from(false).to(true)
      end
    end
    describe "on update" do
      before { subject.save(validate: false) }
      it "creates a version" do
        expect {
          subject.dc_title = ["Changed Title"]
          subject.save(validate: false)
        }.to change {
          subject.versions.all.size
        }.by(1)
      end
    end
  end

end
