module Ddr
  module Models
    module HasStructMetadata
      extend ActiveSupport::Concern

      included do
        has_file_datastream name: Ddr::Datastreams::STRUCT_METADATA,
                            type: Ddr::Datastreams::StructuralMetadataDatastream
      end

      def structure
        unless @structure
          if datastreams[Ddr::Datastreams::STRUCT_METADATA].content
            @structure = Ddr::Models::Structure.new(Nokogiri::XML(datastreams[Ddr::Datastreams::STRUCT_METADATA].content))
          end
        end
        @structure
      end

      def multires_image_file_paths
        ::SolrDocument.find(pid).multires_image_file_paths
      end

    end
  end
end
