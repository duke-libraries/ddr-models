RSpec.shared_examples "a DDR model" do

  it_behaves_like "a describable object"
  it_behaves_like "a governable object"
  it_behaves_like "an object that has a display title"
  it_behaves_like "an object that has identifiers"

  describe "ingested by" do
    let(:user) { User.new(username: "foo@bar.com") }
    describe "on create" do
      describe "when :user option passed to #save" do
        describe "and ingested_by is not set" do
          it "sets ingested by" do
            expect { subject.save(user: user) }.to change(subject, :ingested_by).from(nil).to("foo@bar.com")
          end
        end
        describe "and ingested_by is set" do
          before { subject.ingested_by = "bob@example.com" }
          it "does not set ingested by" do
            expect { subject.save(user: user) }.not_to change(subject, :ingested_by)
          end
        end
      end
      describe "when :user option passed to #save!" do
        describe "and ingested_by is not set" do
          it "sets ingested by" do
            expect { subject.save!(user: user) }.to change(subject, :ingested_by).from(nil).to("foo@bar.com")
          end
        end
        describe "and ingested_by is set" do
          before { subject.ingested_by = "bob@example.com" }
          it "does not set ingested by" do
            expect { subject.save!(user: user) }.not_to change(subject, :ingested_by)
          end
        end
      end
    end
    describe "saving after create" do
      before { subject.save! }
      it "does not set ingested_by" do
        expect { subject.save(user: user) }.not_to change(subject, :ingested_by)
        expect { subject.save!(user: user) }.not_to change(subject, :ingested_by)
      end
    end
  end

  describe "ingestion date" do
    describe "on create" do
      describe "when it's set" do
        before { subject.ingestion_date = "2017-01-13T19:03:15Z" }
        it "preserves the date" do
          expect { subject.save! }.not_to change(subject, :ingestion_date)
        end
      end
      describe "when it's not set" do
        it "sets the date" do
          expect { subject.save! }.to change(subject, :ingestion_date)
        end
      end
    end
  end

  describe "permanent ID assignment" do
    describe "when auto assignment is enabled" do
      before do
        allow(Ddr::Models).to receive(:auto_assign_permanent_id) { true }
      end
      describe "and a permanent ID is pre-assigned" do
        before do
          subject.permanent_id = "foo"
        end
        it "does not assign a permanent ID" do
          expect { subject.save(validate: false) }.not_to change(subject, :permanent_id)
        end
      end
      describe "and no permanent ID has been pre-assigned" do
        before do
          expect(Ddr::Models::PermanentId).to receive(:assign!).with(subject) { nil }
          subject.save(validate: false)
        end
      end
    end
    describe "when auto assignment is disabled" do
      before do
        allow(Ddr::Models).to receive(:auto_assign_permanent_id) { false }
      end
      it "does not assign a permanent ID" do
        expect { subject.save(validate: false) }.not_to change(subject, :permanent_id)
      end
    end
  end

  describe "events" do
    describe "ingestion" do
      it "creates an ingestion event" do
        expect { subject.save! }.to change { Ddr::Events::IngestionEvent.for_object(subject).count }.by(1)
      end
    end
    describe "update" do
      before { subject.save! }
      it "creates an update event" do
        expect { subject.save! }.to change { Ddr::Events::UpdateEvent.for_object(subject).count }.by(1)
      end
      describe "with options" do
        let(:user) { FactoryGirl.create(:user) }
        it "creates an update event with options" do
          subject.title = [ "Changed Title" ]
          subject.save(user: user, summary: "This event rocks!", comment: "I was testing things", detail: "A bunch of extra stuff I want to record")
          event = Ddr::Events::UpdateEvent.for_object(subject).last
          expect(event.user_key).to eq(user.to_s)
          expect(event.summary).to eq "This event rocks!"
          expect(event.comment).to eq "I was testing things"
        end
      end
    end
    describe "deaccession" do
      before { subject.save! }
      it "creates a deaccession event" do
        expect { subject.deaccession }.to change { Ddr::Events::DeaccessionEvent.for_object(subject).count }.by(1)
      end
      it "records attributes with the event" do
        allow(subject).to receive(:permanent_id) { "foo" }
        subject.deaccession
        event = Ddr::Events::DeaccessionEvent.for_object(subject).first
        expect(event.permanent_id).to eq "foo"
      end
    end
    describe "on deletion with #destroy" do
      before { subject.save! }
      it "creates a deletion event" do
        expect { subject.destroy }.to change { Ddr::Events::DeletionEvent.for_object(subject).count }.from(0).to(1)
      end
      it "records attributes with the event" do
        allow(subject).to receive(:permanent_id) { "foo" }
        subject.destroy
        event = Ddr::Events::DeletionEvent.for_object(subject).first
        expect(event.permanent_id).to eq "foo"
      end
    end
    describe "last virus check" do
      before { subject.save! }
      let!(:fixity_check) { Ddr::Events::FixityCheckEvent.new }
      before { allow(subject).to receive(:last_fixity_check) { fixity_check } }
      its(:last_fixity_check_on) { should eq(fixity_check.event_date_time) }
      its(:last_fixity_check_outcome) { should eq(fixity_check.outcome) }
    end
  end
end
