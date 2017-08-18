require 'active_fedora'

module Ddr
  module Datastreams
    extend ActiveSupport::Autoload

    ADMIN_METADATA    = "adminMetadata"
    CAPTION           = "caption"
    CONTENT           = "content"
    DC                = "DC"
    DESC_METADATA     = "descMetadata"
    EXTRACTED_TEXT    = "extractedText"
    FITS              = "fits".freeze
    INTERMEDIATE_FILE = "intermediateFile".freeze
    MULTIRES_IMAGE    = "multiresImage"
    RELS_EXT          = "RELS-EXT"
    STREAMABLE_MEDIA  = "streamableMedia"
    STRUCT_METADATA   = "structMetadata"
    THUMBNAIL         = "thumbnail"

    CREATE = "create.repo_file"
    SAVE = "save.repo_file"
    DELETE = "delete.repo_file"

    CHECKSUM_TYPE_MD5 = "MD5"
    CHECKSUM_TYPE_SHA1 = "SHA-1"
    CHECKSUM_TYPE_SHA256 = "SHA-256"
    CHECKSUM_TYPE_SHA384 = "SHA-384"
    CHECKSUM_TYPE_SHA512 = "SHA-512"

    CHECKSUM_TYPES = [ CHECKSUM_TYPE_MD5, CHECKSUM_TYPE_SHA1, CHECKSUM_TYPE_SHA256, CHECKSUM_TYPE_SHA384, CHECKSUM_TYPE_SHA512 ]

    autoload :AdministrativeMetadataDatastream
    autoload :CaptionDatastream
    autoload :ContentDatastream
    autoload :DatastreamBehavior
    autoload :DeleteExternalFiles
    autoload :DescriptiveMetadataDatastream
    autoload :ExternalFileDatastream
    autoload :FitsDatastream
    autoload :IntermediateFileDatastream
    autoload :MetadataDatastream
    autoload :MultiresImageDatastream
    autoload :PlainTextDatastream
    autoload :StreamableMediaDatastream
    autoload :StructuralMetadataDatastream

    mattr_accessor :update_derivatives_on_changed do
      [ CONTENT, INTERMEDIATE_FILE ]
    end

  end
end
