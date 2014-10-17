module Ddr
  module Models
    module HasProperties
      extend ActiveSupport::Concern
  
      included do
        has_metadata name: Ddr::Datastreams::PROPERTIES, 
                     type: Ddr::Datastreams::PropertiesDatastream,
                     versionable: true, 
                     label: "Properties for this object", 
                     control_group: 'M'
      end
    end
  end
end