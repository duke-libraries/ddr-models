RSpec.shared_examples "an object that has a display title" do
  describe "#title_display" do
    let(:object) { described_class.new }
    subject { object.title_display }
    context "has title" do
      before { object.descMetadata.title = [ 'Title' ] }
      it "should return the first title" do
        expect(subject).to eq('Title')
      end
    end
    context "has no title, has identifier" do
      before { object.descMetadata.identifier = [ 'id001' ] }
      it "should return the first identifier" do
        expect(subject).to eq('id001')
      end
    end
    # Only objects with content implement :original_filename
    # This test worked before b/c allowing rspec to stub methods
    # that aren't defined on object. This rspec-mocks config setting prevents that:
    #
    #   verify_partial_doubles = true
    #
    # context "has no title, no identifier, has original_filename" do
    #   before { allow(object).to receive(:original_filename) { "file.txt" } }
    #   it "should return original_filename" do
    #     expect(subject).to eq "file.txt"
    #   end
    # end
    context "has no title, no identifier, no original_filename" do
      let(:object) { described_class.new(:pid => 'duke-test') }
      it "should return the PID in square brackets" do
        expect(subject).to eq "[duke-test]"
      end
    end
  end
end

RSpec.shared_examples "an object that has identifiers" do
  describe "#all_identifiers" do
    let(:object) { described_class.new(pid: 'test:3') }
    subject { object.all_identifiers }
    context "has descriptive identifiers, local ID, permanent ID, and PID" do
      before do
        object.descMetadata.identifier = [ 'ID001', 'ID002' ]
        object.local_id = 'LOCAL_ID_A'
        object.permanent_id = 'ark:/999999/cd3'
      end
      it "should return all the identifiers" do
        expect(subject).to match_array([ 'ID001', 'ID002', 'LOCAL_ID_A', 'ark:/999999/cd3', 'test:3' ])
      end
    end
    context "no descriptive identifiers or local ID" do
      before { object.permanent_id = 'ark:/999999/cd3' }
      it "should return the permanent ID and PID" do
        expect(subject).to match_array([ 'ark:/999999/cd3', 'test:3' ])
      end
    end
  end
end
