def mock_object(opts={})
  double("object", {create_date: "2014-01-01T01:01:01.000Z", modified_date: "2014-06-01T01:01:01.000Z"}.merge(opts))
end

RSpec.shared_examples "a preservation-related event" do
  subject { described_class.new }
  it "should have an event_type" do
    expect(subject.preservation_event_type).not_to be_nil
  end
  it "should have a PREMIS representation" do
    expect(subject).to respond_to :as_premis
    expect(subject).to respond_to :to_xml
  end
end

RSpec.shared_examples "an event that reindexes its object after save" do
  it "should implement the reindexing concern" do
    expect(subject).to be_a Ddr::Events::ReindexObjectAfterSave
  end
  context "when object is present" do
    let(:object) { mock_object }
    before do
      allow(subject).to receive(:object) { object }
    end
    it "should reindex its object after save" do
      expect(object).to receive(:update_index)
      subject.save(validate: false)
    end
  end
end

RSpec.shared_examples "an event" do
  describe "validation" do
    it "should require a PID" do
      expect(subject).not_to be_valid
      expect(subject.errors[:pid]).to include "can't be blank"
    end
    it "should require an event_date_time" do
      allow(subject).to receive(:event_date_time) { nil } # b/c set to default after init
      expect(subject).not_to be_valid
      expect(subject.errors[:event_date_time]).to include "can't be blank"
    end
    it "should require a valid outcome" do
      subject.outcome = Ddr::Events::Event::SUCCESS
      subject.valid?
      expect(subject.errors).not_to have_key :outcome
      subject.outcome = Ddr::Events::Event::FAILURE
      subject.valid?
      expect(subject.errors).not_to have_key :outcome
      subject.outcome = "Some other value"
      expect(subject).not_to be_valid
      expect(subject.errors[:outcome]).to include "\"Some other value\" is not a valid event outcome"
    end
  end

  describe "outcome setters and getters" do
    it "should encapsulate access" do
      subject.success!
      expect(subject.outcome).to eq Ddr::Events::Event::SUCCESS
      expect(subject).to be_success
      subject.failure!
      expect(subject.outcome).to eq Ddr::Events::Event::FAILURE
      expect(subject).to be_failure
    end
  end

  describe "setting defaults" do
    context "after initialization" do
      it "should set outcome to 'success'" do
        expect(subject.outcome).to eq Ddr::Events::Event::SUCCESS
      end
      it "should set event_date_time" do
        expect(subject.event_date_time).to be_present
      end
      it "should set software" do
        expect(subject.software).to be_present
        expect(subject.software).to eq subject.send(:default_software)
      end
      it "should set summary" do
        expect(subject.summary).to eq subject.send(:default_summary)
      end
    end
    context "when attributes are set" do
      let(:obj) { ActiveFedora::Base.create }
      let(:event) { described_class.new(pid: obj.pid, outcome: Ddr::Events::Event::FAILURE, event_date_time: Time.utc(2013), software: "Test", summary: "A terrible disaster") }
      it "should not overwrite attributes" do
        expect { event.send(:set_defaults) }.not_to change { event.outcome }
        expect { event.send(:set_defaults) }.not_to change { event.event_date_time }
        expect { event.send(:set_defaults) }.not_to change { event.software }
        expect { event.send(:set_defaults) }.not_to change { event.summary }
      end
    end
  end

  describe "object getter" do
    subject { described_class.new(pid: "test:123") }
    let(:object) { mock_object }
    before { allow(ActiveFedora::Base).to receive(:find).with("test:123") { object } }
    it "should retrieve the object" do
      expect(subject.object).to eq object
    end
    it "should cache the object" do
      expect(ActiveFedora::Base).to receive(:find).with("test:123").once
      subject.object
      subject.object
    end
  end

  describe "object setter" do
    let(:object) { mock_object(pid: "test:123") }
    it "should set the event pid and object" do
      allow(object).to receive(:new_record?) { false }
      subject.object = object
      expect(subject.pid).to eq "test:123"
      expect(subject.object).to eq object
    end
    it "should raise an ArgumentError if object is a new record" do
      allow(object).to receive(:new_record?) { true }
      expect { subject.object = object }.to raise_error ArgumentError
    end
  end

  describe "event_date_time string representation" do
    subject { described_class.new(event_date_time: Time.utc(2014, 6, 4, 11, 7, 35)) }
    it "should conform to the specified format" do
      expect(subject.event_date_time_s).to eq "2014-06-04T11:07:35.000Z"
    end
  end

  describe "rendering who/what performed the action" do
    context "when performed by a user" do
      let(:user) { FactoryGirl.build(:user) }
      before do
        subject.user = user
      end
      it "should render the user" do
        expect(subject.performed_by).to eq(user.user_key)
      end
    end
    context "when not performed by a user" do
      it "should render 'SYSTEM'" do
        expect(subject.performed_by).to eq "SYSTEM"
      end
    end
  end

  describe "when the exception attribute is set" do
    before { subject.exception = "Gah!" }
    it "should be persisted as a failure" do
      subject.save(validate: false)
      expect(subject).to be_failure
    end
  end
end
