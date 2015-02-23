require 'active_fedora'

module Ddr
  module Datastreams
    extend ActiveSupport::Autoload

    CONTENT = "content"
    DC = "DC"
    DEFAULT_RIGHTS = "defaultRights"
    DESC_METADATA = "descMetadata"
    PROPERTIES = "properties"
    RELS_EXT = "RELS-EXT"
    RIGHTS_METADATA = "rightsMetadata"
    STRUCT_METADATA = "structMetadata"
    THUMBNAIL = "thumbnail"

    CHECKSUM_TYPE_MD5 = "MD5"
    CHECKSUM_TYPE_SHA1 = "SHA-1"
    CHECKSUM_TYPE_SHA256 = "SHA-256"
    CHECKSUM_TYPE_SHA384 = "SHA-384"
    CHECKSUM_TYPE_SHA512 = "SHA-512"

    CHECKSUM_TYPES = [ CHECKSUM_TYPE_MD5, CHECKSUM_TYPE_SHA1, CHECKSUM_TYPE_SHA256, CHECKSUM_TYPE_SHA384, CHECKSUM_TYPE_SHA512 ]

    autoload :AdminMetadataDatastream
    autoload :DescriptiveMetadataDatastream
    #autoload :PreservationMetadataDatastream
    autoload :PropertiesDatastream
    autoload :StructMetadataDatastream
    autoload :DatastreamBehavior

  end
end
