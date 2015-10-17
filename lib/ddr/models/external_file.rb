module Ddr::Models
  class ExternalFile < ActiveFedora::Base

    belongs_to :component, predicate: Ddr::Vocab::Asset.isExternalFileFor, class_name: "Component"

    property :use, predicate: Ddr::Vocab::Asset.use, multiple: false
    property :location, predicate: Ddr::Vocab::Asset.location, multiple: false
    property :mime_type, predicate: ::RDF::DC.format, multiple: false
    property :resource_type, predicate: ::RDF::DC.type, multiple: false

    # TODO - validation?

  end
end
