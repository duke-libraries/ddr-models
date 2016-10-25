RSpec.shared_examples "a DDR model" do

  it_behaves_like "a describable object"
  it_behaves_like "a governable object"
  it_behaves_like "an access controllable object"
  it_behaves_like "an object that has a display title"
  it_behaves_like "an object that has identifiers"

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
      expect(events.first[:changes]).to eq({"title"=>[[], ["My Title Changed"]]})
      expect(events.first[:created]).to be true
      expect(events.first[:pid]).to eq(subject.pid)
      expect(events.last[:changes]).to eq({"title"=>[["My Title Changed"], ["My Title Changed Again"]]})
      expect(events.last[:created]).to be false
      expect(events.last[:pid]).to eq(subject.pid)
    end
  end

  describe "events" do
    before {
      subject.permanent_id = "ark:/99999/fk4zzz"
      subject.save(validate: false)
      allow(Ddr::Jobs::PermanentId::MakeUnavailable).to receive(:perform) { nil }
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
