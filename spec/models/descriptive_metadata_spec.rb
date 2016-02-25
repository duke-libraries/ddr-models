require 'spec_helper'

module Ddr::Models
  RSpec.describe DescriptiveMetadata do

    let(:obj) { FactoryGirl.build(:item) }

    describe "terminology" do
      subject { described_class.unqualified_names }
      it { is_expected.to_not include(:license) }
      it "should have a term for each term name in the RDF::DC vocab, except :license" do
        expect(subject).to include(*(Ddr::Vocab::Vocabulary.term_names(RDF::DC) - [:license]))
      end
      it "should have a term for each term name in the DukeTerms vocab" do
        expect(subject).to include(*Ddr::Vocab::Vocabulary.term_names(Ddr::Vocab::DukeTerms))
      end
    end
    describe ".property_term" do
      it "should return the correct property term" do
        expect(described_class.property_term(:subject)).to eq(:dc_subject)
      end
    end
    describe "using the set_values and add_value methods" do
      let(:ds) { described_class.new(obj) }
      before { ds.type = ["Photograph"] }
      describe "#set_values" do
        it "should set the values of the term to those supplied" do
          ds.set_values :type, [ "Image", "Still Image" ]
          expect(ds.type).to eq([ "Image", "Still Image" ])
        end
      end
      describe "#add_value" do
        it "should add the supplied value to those of the term" do
          ds.add_value :type, "Image"
          expect(ds.type).to eq([ "Photograph", "Image" ])
        end
      end
    end
  end
end
