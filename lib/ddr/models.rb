require 'ddr/models/engine'
require 'ddr/models/version'
require 'action_view' # https://github.com/haml/haml/issues/695
require 'active_record'
require 'hydra-core'
require 'hydra/validations'

module Ddr
  extend ActiveSupport::Autoload
  extend Deprecation

  autoload :Actions
  autoload :Auth
  autoload :Datastreams
  autoload :Derivatives
  autoload :Events
  autoload :Index
  autoload :Managers
  autoload :Metadata
  autoload :Notifications
  autoload :Utils
  autoload :Vocab

  def self.const_missing(name)
    if name == :IndexFields
      Deprecation.warn(Ddr::Models, "`Ddr::IndexFields` is deprecated and will be removed in ddr-models 3.0." \
                                    " Use `Ddr::Index::Fields` instead.")
      Index::Fields
    else
      super
    end
  end

  module Models
    extend ActiveSupport::Autoload

    autoload :AdminSet
    autoload :Base
    autoload :Cache
    autoload :ChecksumInvalid, 'ddr/models/error'
    autoload :Contact
    autoload :ContentModelError, 'ddr/models/error'
    autoload :DerivativeGenerationFailure, 'ddr/models/error'
    autoload :Describable
    autoload :Error
    autoload :EventLoggable
    autoload :FileCharacterization
    autoload :FileManagement
    autoload :FindingAid
    autoload :FixityCheckable
    autoload :Governable
    autoload :HasAdminMetadata
    autoload :HasAttachments
    autoload :HasChildren
    autoload :HasContent
    autoload :HasIntermediateFile
    autoload :HasMultiresImage
    autoload :HasStructMetadata
    autoload :HasThumbnail
    autoload :Indexing
    autoload :MediaType
    autoload :NotFoundError, 'ddr/models/error'
    autoload :PermanentId
    autoload :RightsStatement
    autoload :SolrDocument
    autoload :Streamable
    autoload :Structure
    autoload :WithContentFile
    autoload :YearFacet

    autoload_under "licenses" do
      autoload :AdminPolicyLicense
      autoload :EffectiveLicense
      autoload :License
      autoload :InheritedLicense
      autoload :ParentLicense
    end

    module Structures
      extend ActiveSupport::Autoload

      autoload :Agent
      autoload :Div
      autoload :File
      autoload :FileGrp
      autoload :FileSec
      autoload :FLocat
      autoload :Fptr
      autoload :MetsHdr
      autoload :Mptr
      autoload :StructMap
    end

    # Image server URL
    mattr_accessor :image_server_url

    mattr_accessor :permanent_id_target_url_base do
      "https://repository.duke.edu/id/"
    end

    # Home directory for FITS
    mattr_accessor :fits_home

    # Run file characterization or not?
    mattr_accessor :characterize_files do
      false
    end
    class << self
      alias :characterize_files? :characterize_files
    end

    mattr_accessor :ead_xml_base_url do
      "http://library.duke.edu/rubenstein/findingaids/"
    end

    # Application temp dir - defaults to system temp dir
    mattr_accessor :tempdir do
      Dir.tmpdir
    end

    # Is repository locked?  Default is false.
    # A locked repository behaves as though each object in the repository is locked.
    mattr_accessor :repository_locked do
      false
    end

    mattr_accessor :auto_assign_permanent_id do
      false
    end

    mattr_accessor :auto_update_permanent_id do
      false
    end

    # File path to vips
    mattr_accessor :vips_path

    mattr_accessor :default_mime_type do
      "application/octet-stream"
    end

    # Maps file extensions to preferred media types
    mattr_accessor :preferred_media_types do
      {
        '.mp4'  => 'video/mp4',
        '.flv'  => 'video/flv',
        '.webm' => 'video/webm',
        '.aac'  => 'audio/mp4',
        '.m4a'  => 'audio/mp4',
        '.f4a'  => 'audio/mp4',
        '.mp3'  => 'audio/mpeg',
        '.ogg'  => 'audio/ogg',
        '.oga'  => 'audio/ogg',
      }
    end

    # Yields an object with module configuration accessors
    def self.configure
      yield self
    end

  end
end

Dir[Ddr::Models::Engine.root.to_s + "/app/models/*.rb"].each { |m| require m }
