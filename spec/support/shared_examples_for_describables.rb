RSpec.shared_examples "a describable object" do

  context "having an identifier" do
    before do
      subject.identifier = ["id001"]
      subject.save!
    end
    it "is findable by identifier" do
      expect(described_class.find_by_identifier('id001')).to include subject
    end
  end
  describe "#desc_metadata_terms" do
    it "has a default value" do
      expect(subject.desc_metadata_terms).to eq Ddr::Datastreams::DescriptiveMetadataDatastream.term_names
    end
    describe "arguments" do
      it "with fixed results" do
        expect(subject.desc_metadata_terms(:dcterms)).to eq(Ddr::Vocab::Vocabulary.term_names(RDF::DC11) + (Ddr::Vocab::Vocabulary.term_names(RDF::DC) - Ddr::Vocab::Vocabulary.term_names(RDF::DC11)))
        expect(subject.desc_metadata_terms(:dcterms)).to match_array Ddr::Vocab::Vocabulary.term_names(RDF::DC)
        expect(subject.desc_metadata_terms(:duke)).to eq Ddr::Vocab::Vocabulary.term_names(Ddr::Vocab::DukeTerms)
        expect(subject.desc_metadata_terms(:dcterms_elements11)).to eq Ddr::Vocab::Vocabulary.term_names(RDF::DC11)
        expect(subject.desc_metadata_terms(:defined_attributes)).to match_array Ddr::Vocab::Vocabulary.term_names(RDF::DC11)
      end
      context "with variable results" do
        before do
          subject.descMetadata.title = ["Object Title"]
          subject.descMetadata.creator = ["Duke University Libraries"]
          subject.descMetadata.identifier = ["id001"]
          subject.save!
        end
        it "accepts an :empty argument" do
          expect(subject.desc_metadata_terms(:empty)).to eq(subject.desc_metadata_terms - [:title, :creator, :identifier])
        end
        it "accepts a :present argument" do
          expect(subject.desc_metadata_terms(:present)).to match_array [:title, :creator, :identifier]
        end
      end
    end
  end
  describe "#set_desc_metadata" do
    let(:term_values_hash) { subject.desc_metadata_terms.each_with_object({}) {|t, memo| memo[t] = ["Value"]} }
    it "sets the descMetadata terms to the values of the matching keys in the hash" do
      subject.desc_metadata_terms.each do |t|
        expect(subject).to receive(:set_desc_metadata_values).with(t, ["Value"])
      end
      subject.set_desc_metadata(term_values_hash)
    end
  end
  describe "#set_desc_metadata_values" do
    context "when values == nil" do
      it "sets the term to an empty value" do
        subject.set_desc_metadata_values(:title, nil)
        expect(subject.descMetadata.title).to be_empty
      end
    end
    context "when values is an array" do
      it "rejects empty values from the array" do
        subject.set_desc_metadata_values(:title, ["Object Title", nil, "Alternative Title", ""])
        expect(subject.descMetadata.title).to eq ["Object Title", "Alternative Title"]
      end
    end
  end
end
