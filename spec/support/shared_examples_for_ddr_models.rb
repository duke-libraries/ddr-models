RSpec.shared_examples "a DDR model" do

  describe "#desc_metadata_terms" do
    it "should have a default value" do
      expect(subject.desc_metadata_terms).to match_array(Ddr::Models::DescriptiveMetadata.unqualified_names)
    end
    describe "arguments" do
      it "with fixed results" do
        expect(subject.desc_metadata_terms(:dcterms))
          .to eq(Ddr::Models::MetadataMapping.dc11.unqualified_names + (Ddr::Models::MetadataMapping.dcterms.unqualified_names - Ddr::Models::MetadataMapping.dc11.unqualified_names))
        expect(subject.desc_metadata_terms(:dcterms))
          .to match_array(Ddr::Models::MetadataMapping.dcterms.unqualified_names)
        expect(subject.desc_metadata_terms(:duke)).to eq Ddr::Vocab::Vocabulary.term_names(Ddr::Vocab::DukeTerms)
        expect(subject.desc_metadata_terms(:dcterms_elements11)).to eq Ddr::Vocab::Vocabulary.term_names(RDF::DC11)
        expect(subject.desc_metadata_terms(:defined_attributes)).to match_array Ddr::Vocab::Vocabulary.term_names(RDF::DC11)
      end
      context "with variable results" do
        before do
          subject.desc_metadata.title = ["Object Title"]
          subject.desc_metadata.creator = ["Duke University Libraries"]
          subject.desc_metadata.identifier = ["id001"]
          subject.save
        end
        it "should accept an :empty argument" do
          expect(subject.desc_metadata_terms(:empty)).to eq(subject.desc_metadata_terms - [:title, :creator, :identifier])
        end
        it "should accept a :present argument" do
          expect(subject.desc_metadata_terms(:present)).to match_array [:title, :creator, :identifier]
        end
      end
    end
  end

  describe "#set_desc_metadata" do
    let(:term_values_hash) { subject.desc_metadata_terms.each_with_object({}) {|t, memo| memo[t] = ["Value"]} }
    it "should set the desc_metadata terms to the values of the matching keys in the hash" do
      subject.desc_metadata_terms.each do |t|
        expect(subject.desc_metadata).to receive(:set_values).with(t, ["Value"])
      end
      subject.set_desc_metadata(term_values_hash)
    end
  end

  describe "#to_param" do
    before {
      subject.save(validate: false) if subject.new_record?
    }
    describe "when it has a permanent id" do
      before {
        subject.permanent_id = "ark:/99999/fk4rx95k8w"
      }
      its(:to_param) do
        pending "Resolution of https://github.com/duke-libraries/ddr-models/issues/586"
        is_expected.to eq("fk4rx95k8w")
      end
    end
    describe "when it does not have a permanent id" do
      its(:to_param) { is_expected.to_not be_nil }
      its(:to_param) { is_expected.to eq(subject.id) }
    end
  end

  describe "#title_display" do
    context "when it has a title" do
      before { subject.desc_metadata.title = [ 'Title' ] }
      its(:title_display) { is_expected.to eq('Title') }
    end
    context "when it has no title, but has an identifier" do
      before { subject.desc_metadata.identifier = [ 'id001' ] }
      its(:title_display) { is_expected.to eq('id001') }
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
    context "when it has no title, no identifier, and no original_filename" do
      subject { described_class.new(id: 'duke-test') }
      its(:title_display) { is_expected.to eq "[duke-test]" }
    end
  end

  describe "#all_identifiers" do
    subject { described_class.new(id: 'test-3') }
    context "when it has descriptive identifiers, Fedora 3 PID, local ID, permanent ID, and id" do
      before do
        subject.desc_metadata.identifier = [ 'ID001', 'ID002' ]
        subject.fcrepo3_pid = 'test:92'
        subject.local_id = 'LOCAL_ID_A'
        subject.permanent_id = 'ark:/999999/cd3'
      end
      its(:all_identifiers) {
        is_expected.to match_array([ 'ID001', 'ID002', 'test:92', 'LOCAL_ID_A', 'ark:/999999/cd3', 'test-3' ])
      }
    end
    context "when it has no descriptive identifiers, Fedora 3 PID, or local ID" do
      before { subject.permanent_id = 'ark:/999999/cd3' }
      its(:all_identifiers) {
        is_expected.to match_array([ 'ark:/999999/cd3', 'test-3' ])
      }
    end
  end

  describe ".having_local_id" do
    let(:obj1) {
      described_class.new(local_id: "obj1").tap { |obj| obj.save(validate: false) }
    }
    let(:obj2) {
      described_class.new(local_id: "obj2").tap { |obj| obj.save(validate: false) }
    }
    specify {
      expect(described_class.having_local_id("obj1")).to include(obj1)
      expect(described_class.having_local_id("obj1")).not_to include(obj2)
      expect(described_class.having_local_id("obj2")).not_to include(obj1)
      expect(described_class.having_local_id("obj2")).to include(obj2)
    }
  end

  describe ".find_by_unique_id" do
    before {
      subject.permanent_id = "ark:/99999/fk4rx95k8w"
      subject.save(validate: false)
    }
    it "finds by Fedora id" do
      expect(described_class.find_by_unique_id(subject.id)).to eq(subject)
    end
    it "finds by permanent id" do
      expect(described_class.find_by_unique_id("ark:/99999/fk4rx95k8w")).to eq(subject)
    end
    it "finds by permanent id suffix" do
      expect(described_class.find_by_unique_id("fk4rx95k8w")).to eq(subject)
    end
  end

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
      describe "when autoversion is enabled" do
        before { allow(subject).to receive(:autoversion?) { true } }
        it "creates a version" do
          expect { subject.save(validate: false) }
            .to change(subject, :has_versions?).from(false).to(true)
        end
      end
      describe "when autoversion is disabled" do
        before { allow(subject).to receive(:autoversion?) { false } }
        it "does not create a version" do
          expect { subject.save(validate: false) }
            .not_to change(subject, :has_versions?)
        end
      end
    end
    describe "on update" do
      describe "when autoversion is enabled" do
        before {
          allow(subject).to receive(:autoversion?) { true }
          subject.save(validate: false)
        }
        it "creates a version" do
          expect {
            subject.dc_title = ["Changed Title"]
            subject.save(validate: false)
          }.to change {
            subject.versions.all.size
          }.by(1)
        end
      end
      describe "when autoversion is disabled" do
        before {
          allow(subject).to receive(:autoversion?) { false }
          subject.save(validate: false)
        }
        it "does not create a version" do
          expect {
            subject.dc_title = ["Changed Title"]
            subject.save(validate: false)
          }.not_to change {
            subject.versions.all.size
          }
        end
      end
    end
  end

  describe "fixity check" do
    before do
      subject.thumbnail.content = '1234567890'
      subject.save(validate: false)
    end
    specify {
      expect { subject.check_fixity }.to change(subject.fixity_checks, :count).from(0).to(1)
    }
    describe "results" do
      let(:results) { subject.check_fixity }
      specify {
        expect(results).to be_success
      }
      specify {
        expect(results[:thumbnail]).to be true
      }
      describe "failure" do
        before {
          allow(subject.thumbnail).to receive(:check_fixity) { false }
        }
        specify {
          expect(results).not_to be_success
        }
      end
    end
  end

  describe "after save notification" do
    let(:events) { [] }
    before {
      @subscriber = ActiveSupport::Notifications.subscribe(Ddr::Models::Base::SAVE_NOTIFICATION) do |name, start, finish, id, payload|
        events << payload[:id]
      end
    }
    after {
      ActiveSupport::Notifications.unsubscribe(@subscriber)
    }
    specify {
      subject.save(validate: false)
      expect(events).to eq([subject.id])
    }
  end
end
