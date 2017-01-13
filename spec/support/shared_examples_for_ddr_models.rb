RSpec.shared_examples "a DDR model" do

  it_behaves_like "a describable object"
  it_behaves_like "a governable object"
  it_behaves_like "an access controllable object"
  it_behaves_like "an object that has a display title"
  it_behaves_like "an object that has identifiers"

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
    describe "#set_ingestion_date" do
      before { subject.save! }
      describe "when it's set" do
        it "raises an error" do
          expect { subject.set_ingestion_date }.to raise_error(Ddr::Models::Error)
        end
      end
      describe "when it's not set" do
        before do
          subject.ingestion_date = nil
          subject.save!
        end
        describe "and an IngestionEvent exists" do
          before do
            @event = Ddr::Events::IngestionEvent.create(pid: subject.pid)
          end
          it "sets the ingestion_date to the event_date_time of the event" do
            expect { subject.set_ingestion_date }.to change(subject, :ingestion_date).to(@event.event_date_time_s)
          end
        end
        describe "and a CreationEvent exists (but no IngestionEvent)" do
          before do
            @event = Ddr::Events::CreationEvent.create(pid: subject.pid)
          end
          it "sets the ingestion_date to the event_date_time of the event" do
            expect { subject.set_ingestion_date }.to change(subject, :ingestion_date).to(@event.event_date_time_s)
          end
        end
        describe "neither an IngestionEvent nor a CreationEvent exists" do
          it "sets the ingestion_date to the create_date" do
            expect { subject.set_ingestion_date }.to change(subject, :ingestion_date).to(subject.create_date)
          end
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

  describe "notification on save" do
    let(:events) { [] }
    before {
      @subscriber = ActiveSupport::Notifications.subscribe("save.#{described_class.to_s.underscore}") do |name, start, finish, id, payload|
        events << payload
      end
    }
    after {
      ActiveSupport::Notifications.unsubscribe(@subscriber)
    }
    it "happens when save succeeds" do
      subject.title = [ "My Title Changed" ]
      subject.save
      subject.title = [ "My Title Changed Again" ]
      subject.save
      expect(events.first[:changes]).to include({"title"=>[[], ["My Title Changed"]]})
      expect(events.first[:created]).to be true
      expect(events.first[:pid]).to eq(subject.pid)
      expect(events.last[:changes]).to eq({"title"=>[["My Title Changed"], ["My Title Changed Again"]]})
      expect(events.last[:created]).to be false
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
        expect(events.first.name).to eq("published.workflow.#{described_class.to_s.underscore}")
      end
      it "happens on unpublish!" do
        subject.workflow_state = "unpublished"
        subject.save(validate: false)
        expect(events.size).to eq(1)
        expect(events.first.name).to eq("unpublished.workflow.#{described_class.to_s.underscore}")
      end
    end
  end

  describe "events" do
    before {
      subject.save(validate: false)
    }
    describe "deaccession" do
      it "creates a deaccession event" do
        expect { subject.deaccession }.to change { Ddr::Events::DeaccessionEvent.for_object(subject).count }.by(1)
      end
    end
    describe "on deletion with #destroy" do
      it "creates a deletion event" do
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

  describe "move first desc metadata identifier to local id" do
    let(:local_id) { 'locl001' }
    let(:identifiers) { [ 'id001', 'id002' ] }
    context "no desc metadata identifiers" do
      context "local id present" do
        before { subject.local_id = local_id }
        it "should not change the local id" do
          result = subject.move_first_identifier_to_local_id
          expect(result).to be false
          expect(subject.local_id).to eq(local_id)
        end
      end
    end
    context "one desc metadata identifier" do
      before { subject.identifier = Array(identifiers.first) }
      context "local id not present" do
        it "sets the local id and removes the identifier" do
          result = subject.move_first_identifier_to_local_id
          expect(result).to be true
          expect(subject.local_id).to eq(identifiers.first)
          expect(subject.identifier).to be_empty
        end
      end
      context "local id present" do
        before { subject.local_id = local_id }
        context "replace option is true" do
          it "sets the local id and removes the identifier" do
            result = subject.move_first_identifier_to_local_id
            expect(result).to be true
            expect(subject.local_id).to eq(identifiers.first)
            expect(subject.identifier).to be_empty
          end
        end
        context "replace option is false" do
          context "local id matches first identifier" do
            before { subject.identifier = Array(local_id) }
            it "removes the identifier" do
              result = subject.move_first_identifier_to_local_id(replace: false)
              expect(result).to be true
              expect(subject.local_id).to eq(local_id)
              expect(subject.identifier).to be_empty
            end
          end
          context "local id does not match first identifier" do
            it "does not change the local id and does not remove the identifier" do
              result = subject.move_first_identifier_to_local_id(replace: false)
              expect(result).to be false
              expect(subject.local_id).to eq(local_id)
              expect(subject.identifier).to eq(Array(identifiers.first))
            end
          end
        end
      end
    end
    context "more than one desc metadata identifer" do
      before { subject.identifier = identifiers }
      context "local id not present" do
        it "sets the local id and removes the identifier" do
          result = subject.move_first_identifier_to_local_id
          expect(result).to be true
          expect(subject.local_id).to eq(identifiers.first)
          expect(subject.identifier).to eq(Array(identifiers.last))
        end
      end
      context "local id present" do
        before { subject.local_id = local_id }
        context "replace option is true" do
          it "sets the local id and removes the identifier" do
            result = subject.move_first_identifier_to_local_id
            expect(result).to be true
            expect(subject.local_id).to eq(identifiers.first)
            expect(subject.identifier).to eq(Array(identifiers.last))
          end
        end
        context "replace option is false" do
          context "local id matches first identifier" do
            before { subject.identifier = [ local_id, identifiers.last ] }
            it "removes the identifier" do
              result = subject.move_first_identifier_to_local_id(replace: false)
              expect(result).to be true
              expect(subject.local_id).to eq(local_id)
              expect(subject.identifier).to eq(Array(identifiers.last))
            end
          end
          context "local id does not match first identifier" do
            it "does not change the local id and does not remove the identifier" do
              result = subject.move_first_identifier_to_local_id(replace: false)
              expect(result).to be false
              expect(subject.local_id).to eq(local_id)
              expect(subject.identifier).to eq(identifiers)
            end
          end
        end
      end
    end
  end

end
