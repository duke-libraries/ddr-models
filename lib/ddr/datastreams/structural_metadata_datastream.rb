require "rdf/vocab"

module Ddr
  module Datastreams
    class StructuralMetadataDatastream < ActiveFedora::Datastream
      def self.default_attributes
        super.merge({ mimeType: 'text/xml', dsLabel: 'Structural metadata for this object' })
      end
    end
  end
end
