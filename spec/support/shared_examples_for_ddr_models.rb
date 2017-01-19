RSpec.shared_examples "a DDR model" do

  it_behaves_like "a describable object"
  it_behaves_like "a governable object"
  it_behaves_like "an access controllable object"
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

  describe "notification on update" do
    let(:events) { [] }
    before do
      @subscriber = ActiveSupport::Notifications.subscribe("update.#{described_class.to_s.underscore}.repo_object") do |name, start, finish, id, payload|
        events << payload
      end
    end
    after do
      ActiveSupport::Notifications.unsubscribe(@subscriber)
    end
    it "happens when save succeeds" do
      subject.creator = [ "Me" ]
      subject.save!
      subject.creator = [ "You" ]
      subject.save!
      expect(events.last[:detail]).to match /\{"creator"=\>\[\[\"Me\"\], \["You"\]\]\}/
      expect(events.last[:pid]).to eq(subject.pid)
    end
  end

  describe "notification on workflow state change" do
    let(:events) { [] }
    before {
      @subscriber = ActiveSupport::Notifications.subscribe(/workflow\.#{described_class.to_s.underscore}/) do |*args|
        events << ActiveSupport::Notifications::Event.new(*args)
      end
    }
    after {
      ActiveSupport::Notifications.unsubscribe(@subscriber)
    }
    it "doesn't happen on create" do
      subject.workflow_state = "published"
      subject.save(validate: false)
      expect(events).to be_empty
    end
    describe "with a previously persisted object" do
      before do
        subject.save(validate: false)
      end
      it "happens on publish!" do
        subject.workflow_state = "published"
        subject.save(validate: false)
        expect(events.size).to eq(1)
        expect(events.first.name).to eq("published.workflow.#{described_class.to_s.underscore}.repo_object")
      end
      it "happens on unpublish!" do
        subject.workflow_state = "unpublished"
        subject.save(validate: false)
        expect(events.size).to eq(1)
        expect(events.first.name).to eq("unpublished.workflow.#{described_class.to_s.underscore}.repo_object")
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
    end
    describe "deaccession" do
      before { subject.save! }
      it "creates a deaccession event" do
        expect { subject.deaccession }.to change { Ddr::Events::DeaccessionEvent.for_object(subject).count }.by(1)
      end
    end
    describe "on deletion with #destroy" do
      before { subject.save! }
      it "creates a deletion event" do
        expect { subject.destroy }.to change { Ddr::Events::DeletionEvent.for_object(subject).count }.from(0).to(1)
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
