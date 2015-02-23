module Ddr
  module Models
    module HasStructMetadata
      extend ActiveSupport::Concern

      included do
        has_metadata "structMetadata",
                     type: Ddr::Datastreams::StructMetadataDatastream,
                     versionable: true,
                     control_group: "M"

        has_attributes :file_group, :file_use, :order,
                       datastream: "structMetadata", multiple: false
      end

    end
  end
end
