module Ddr::Vocab

  class DukeTerms < RDF::StrictVocabulary("http://library.duke.edu/metadata/terms/")

    RDFVocabularyParser.new(
      File.join(File.dirname( __FILE__ ), "sources", "duketerms.rdf"),
      "http://library.duke.edu/metadata/terms/").
      term_symbols.sort.each do |term|
      property term, type: "rdf:Property".freeze
    end

  end
end
