module Ddr
  module Models
    module HasContentMetadata
      extend ActiveSupport::Concern

      included do
        has_file_datastream :name => Ddr::Datastreams::CONTENT_METADATA, 
                            :type => Ddr::Datastreams::ContentMetadataDatastream,
                            :versionable => true, 
                            :label => "Structural Content Data for this object", 
                            :control_group => 'M'

        index :content_metadata_parsed, :symbol
      end

      def content_metadata_parsed
        contentMetadata.parse.to_json if contentMetadata.has_content?
      end
      
    end
  end
end
