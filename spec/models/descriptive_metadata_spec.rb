require 'spec_helper'

module Ddr::Models
  RSpec.describe DescriptiveMetadata do

    let(:obj) { FactoryGirl.build(:item) }

    describe "terminology" do
      subject { described_class.unqualified_names }
      it { is_expected.to_not include(:license) }
      it "has a term for each term name in the RDF::DC vocab, except :license" do
        expect(subject).to include(*(Ddr::Vocab::Vocabulary.term_names(RDF::DC) - [:license]))
      end
      it "has a term for each term name in the DukeTerms vocab" do
        expect(subject).to include(*Ddr::Vocab::Vocabulary.term_names(Ddr::Vocab::DukeTerms))
      end
    end

    describe ".property_term" do
      it "returns the correct property term" do
        expect(described_class.property_term(:subject)).to eq(:dc_subject)
        expect(described_class.property_term('subject')).to eq(:dc_subject)
      end
    end

    describe "using the set_values and add_value methods" do
      subject { described_class.new(obj) }
      before { subject.type = ["Photograph"] }

      describe "#set_values" do
        it "sets the values of the term to those supplied" do
          subject.set_values :type, [ "Image", "Still Image" ]
          expect(subject.type).to eq([ "Image", "Still Image" ])
        end
        context "when values == nil" do
          it "sets the term to an empty value" do
            subject.set_values(:title, nil)
            expect(subject.title).to be_empty
          end
        end
        context "when values is an array" do
          it "rejects empty values from the array" do
            subject.set_values(:title, ["Object Title", nil, "Alternative Title", ""])
            expect(subject.title).to eq ["Object Title", "Alternative Title"]
          end
        end
      end

      describe "#add_value" do
        it "should add the supplied value to those of the term" do
          subject.add_value :type, "Image"
          expect(subject.type).to eq([ "Photograph", "Image" ])
        end
      end
    end
  end
end
