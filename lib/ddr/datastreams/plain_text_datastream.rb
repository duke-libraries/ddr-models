module Ddr
  module Datastreams
    class PlainTextDatastream < ActiveFedora::Datastream
      def self.default_attributes
        super.merge(mimeType: "text/plain")
      end
    end
  end
end
