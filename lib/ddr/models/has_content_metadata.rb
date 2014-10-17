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
      end
      
    end
  end
end