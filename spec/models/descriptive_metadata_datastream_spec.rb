require 'rdf/isomorphic'
include RDF::Isomorphic

def sample_metadata_triples(subject_string="_:test")
  triples = <<-EOS
#{subject_string} <http://purl.org/dc/terms/title> "Sample title" .
#{subject_string} <http://purl.org/dc/terms/creator> "Sample, Example" .
#{subject_string} <http://purl.org/dc/terms/type> "Image" .
#{subject_string} <http://purl.org/dc/terms/type> "Still Image" .
#{subject_string} <http://purl.org/dc/terms/spatial> "Durham County (NC)" .
#{subject_string} <http://purl.org/dc/terms/spatial> "Durham (NC)" .
#{subject_string} <http://purl.org/dc/terms/date> "1981-01" .
#{subject_string} <http://purl.org/dc/terms/rights> "The copyright for these materials is unknown." .
#{subject_string} <http://library.duke.edu/metadata/terms/print_number> "12-345-6" .
#{subject_string} <http://library.duke.edu/metadata/terms/series> "Photographic Materials Series" .
#{subject_string} <http://library.duke.edu/metadata/terms/subseries> "Local Court House" .
EOS
end

module Ddr::Datastreams
  RSpec.describe DescriptiveMetadataDatastream do
    describe "terminology" do
      it "should have a term for each term name in the RDF::DC vocab except :license" do
        expect(described_class.term_names).to include(*Ddr::Vocab::Vocabulary.term_names(RDF::DC)-[:license])
      end
      it "should have a term for each term name in the DukeTerms vocab" do
        expect(described_class.term_names).to include(*Ddr::Vocab::Vocabulary.term_names(Ddr::Vocab::DukeTerms))
      end
    end
    describe "properties" do
      subject { described_class.properties.map { |prop| prop[1].predicate } }
      it "should include all the RDF::DC predicates except http://purl.org/dc/terms/license" do
        expected_predicates = Ddr::Vocab::Vocabulary.property_terms(RDF::DC).select { |p| p.to_s != 'http://purl.org/dc/terms/license' }
        expect(subject).to include(*expected_predicates)
      end
      it "should include all the DukeTerms predicates" do
        expect(subject).to include(*Ddr::Vocab::Vocabulary.property_terms(Ddr::Vocab::DukeTerms))
      end
    end
    describe "raw content" do
      let(:obj) { Item.new }
      subject { obj.descMetadata }
      before do
        content = sample_metadata_triples(subject.rdf_subject.to_s)
        subject.content = content
        subject.resource.set_subject!(subject.rdf_subject)
      end
      it "should retrieve the content using the terminology" do
        expect(subject.title).to eq(["Sample title"])
        expect(subject.creator).to eq(["Sample, Example"])
        expect(subject.type).to eq(["Image", "Still Image"])
        expect(subject.spatial).to eq(["Durham County (NC)", "Durham (NC)"])
        expect(subject.date).to eq(["1981-01"])
        expect(subject.rights).to eq(["The copyright for these materials is unknown."])
        expect(subject.print_number).to eq(["12-345-6"])
        expect(subject.series).to eq(["Photographic Materials Series"])
        expect(subject.subseries).to eq(["Local Court House"])
      end
    end
    describe "using the terminology setters" do
      let(:obj) { Item.new }
      subject { obj.descMetadata }
      let(:content) { sample_metadata_triples(subject.rdf_subject.to_s) }
      before do
        subject.title = "Sample title"
        subject.creator = "Sample, Example"
        subject.type = ["Image", "Still Image"]
        subject.spatial = ["Durham County (NC)", "Durham (NC)"]
        subject.date = "1981-01"
        subject.rights = "The copyright for these materials is unknown."
        subject.print_number = "12-345-6"
        subject.series = "Photographic Materials Series"
        subject.subseries = "Local Court House"
      end
      its(:resource) { is_expected.to be_isomorphic_with(RDF::Reader.for(:ntriples).new(content)) }
    end
    describe "using the set_values and add_value methods" do
      let(:obj) { Item.new }
      subject { obj.descMetadata }
      before { subject.type = "Photograph" }
      describe "#set_values" do
        it "sets the values of the term to those supplied" do
          subject.set_values :type, [ "Image", "Still Image" ]
          expect(subject.type).to eq([ "Image", "Still Image" ])
        end
        it "does not add blank values" do
          subject.set_values :type, [ "Image", "", nil, "\t" ]
          expect(subject.type).to eq([ "Image" ])
        end
        it "strips whitespace from values" do
          subject.set_values :type, [ "Image", "Still Image " ]
          expect(subject.type).to eq([ "Image", "Still Image" ])
        end
        it "strips control characters from values" do
          subject.set_values :type, [ "Image", "Still\f Image" ]
          expect(subject.type).to eq([ "Image", "Still Image" ])
        end
        it "does not strip CR and LF characters from values" do
          subject.set_values :type, [ "Image", "Still\nImage" ]
          expect(subject.type).to eq([ "Image", "Still\nImage" ])
        end
      end
      describe "#add_value" do
        it "should add the supplied value to those of the term" do
          subject.add_value :type, "Image"
          expect(subject.type).to eq([ "Photograph", "Image" ])
        end
        it "strips whitespace from the value" do
          subject.add_value :type, "Image "
          expect(subject.type).to eq([ "Photograph", "Image" ])
        end
        it "does not add blank values" do
          subject.add_value :type, nil
          subject.add_value :type, ""
          subject.add_value :type, "\t"
          expect(subject.type).to eq(["Photograph"])
        end
      end
    end
    describe "solrization" do
      let(:obj) { Item.new }
      subject { obj.descMetadata }
      before do
        content = sample_metadata_triples(subject.rdf_subject.to_s)
        subject.content = content
        subject.resource.set_subject!(subject.rdf_subject)
      end
      its(:to_solr) { is_expected.to include("title_tesim" => ["Sample title"]) }
      its(:to_solr) { is_expected.to include("creator_tesim" => ["Sample, Example"]) }
      its(:to_solr) { is_expected.to include("type_tesim" => ["Image", "Still Image"]) }
      its(:to_solr) { is_expected.to include("spatial_tesim" => ["Durham County (NC)", "Durham (NC)"]) }
      its(:to_solr) { is_expected.to include("date_tesim" => ["1981-01"]) }
      its(:to_solr) { is_expected.to include("rights_tesim" => ["The copyright for these materials is unknown."]) }
      its(:to_solr) { is_expected.to include("print_number_tesim" => ["12-345-6"]) }
      its(:to_solr) { is_expected.to include("series_tesim" => ["Photographic Materials Series"]) }
      its(:to_solr) { is_expected.to include("subseries_tesim" => ["Local Court House"]) }
    end
  end
end
