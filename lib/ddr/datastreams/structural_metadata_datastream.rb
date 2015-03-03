require "rdf-vocab"

module Ddr
  module Datastreams
    class StructuralMetadataDatastream < MetadataDatastream

      # analogous to METS fileSec "USE" attribute
      property :file_use, predicate: Ddr::Vocab::Asset.fileUse do |index|
        index.as :stored_sortable
      end

      # analogous to METS fileSec "SEQ" or structMap "ORDER" attribute
      property :order, predicate: Ddr::Vocab::Asset.order do |index|
        index.as :stored_sortable
      end

      # analogous to METS fileSec "GROUPID" attribute
      property :file_group, predicate: Ddr::Vocab::Asset.fileGroup do |index|
        index.as :stored_sortable
      end

    end
  end
end
