module Ddr
  module Datastreams
    extend ActiveSupport::Autoload
    extend Deprecation

    CHECKSUM_TYPE_MD5    = "MD5"
    CHECKSUM_TYPE_SHA1   = "SHA-1"
    CHECKSUM_TYPE_SHA256 = "SHA-256"
    CHECKSUM_TYPE_SHA384 = "SHA-384"
    CHECKSUM_TYPE_SHA512 = "SHA-512"

    CHECKSUM_TYPES = [ CHECKSUM_TYPE_MD5, CHECKSUM_TYPE_SHA1, CHECKSUM_TYPE_SHA256, CHECKSUM_TYPE_SHA384, CHECKSUM_TYPE_SHA512 ]

    def self.const_missing(name)
      case name
      when :CONTENT, :EXTRACTED_TEXT, :FITS, :STRUCT_METADATA, :THUMBNAIL
        Deprecation.warn(self, "Ddr::Datastreams::#{name} is deprecated." \
                               " Use Ddr::Models::File::#{name} instead.")
        Ddr::Models::File.const_get(name)
      when :DESC_METADATA
        Deprecation.warn(self, "Ddr::Datastreams::DESC_METADATA is deprecated." \
                               " Use Ddr::Models::Metadata::DESC_METADATA instead.")
        Ddr::Models::Metadata::DESC_METADATA
      when :FitsDatastream
        Deprecation.warn(self, "Ddr::Datastreams::FitsDatastream is deprecated." \
                               " Use Ddr::Models::FitsXmlFile instead.")
        Ddr::Models::FitsXmlFile
      when :StructuralMetadataDatastream
        Deprecation.warn(self, "Ddr::Datastreams::StructuralMetadataDatastream is deprecated." \
                               " Use Ddr::Models::StructuralMetadataFile instead.")
        Ddr::Models::StructuralMetadataFile
      when :PlainTextDatastream
        Deprecation.warn(self, "Ddr::Datastreams::PlainTextDatastream is deprecated." \
                               " Use Ddr::Models::File instead.")
        Ddr::Models::File
      else
        super
      end
    end

  end
end
