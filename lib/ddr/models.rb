require 'ddr/models/engine'
require 'ddr/models/version'

# Awful hack to make Hydra::AccessControls::Permissions accessible
# $: << Gem.loaded_specs['hydra-access-controls'].full_gem_path + "/app/models/concerns"

require 'active_record'

require 'hydra-core'
require 'hydra/validations'

module Ddr
  extend ActiveSupport::Autoload

  autoload :Actions
  autoload :Auth
  autoload :Contacts
  autoload :Datastreams
  autoload :Derivatives
  autoload :Events
  autoload :Index
  autoload :IndexFields
  autoload :Jobs
  autoload :Managers
  autoload :Metadata
  autoload :Notifications
  autoload :Utils
  autoload :Vocab

  module Models
    extend ActiveSupport::Autoload

    autoload :AccessControllable
    autoload :AdminSet
    autoload :Base
    autoload :ChecksumInvalid, 'ddr/models/error'
    autoload :ContentModelError, 'ddr/models/error'
    autoload :DerivativeGenerationFailure, 'ddr/models/error'
    autoload :Describable
    autoload :Error
    autoload :EventLoggable
    autoload :ExternalFile
    autoload :FileManagement
    autoload :FindingAid
    autoload :FixityCheckable
    autoload :Governable
    autoload :HasAdminMetadata
    autoload :HasAttachments
    autoload :HasChildren
    autoload :HasContent
    autoload :HasMultiresImage
    autoload :HasStructMetadata
    autoload :HasThumbnail
    autoload :Indexing
    autoload :MultiresImage
    autoload :SolrDocument
    autoload :StructDiv
    autoload :Structure
    autoload :YearFacet

    autoload_under "licenses" do
      autoload :AdminPolicyLicense
      autoload :EffectiveLicense
      autoload :License
      autoload :InheritedLicense
      autoload :ParentLicense
    end

    autoload_under "metadata" do
      autoload :DescriptiveMetadata
      autoload :Metadata
      autoload :MetadataMapper
      autoload :MetadataMappers
      autoload :MetadataTerm
      autoload :MetadataVocabulary
      autoload :MetadataVocabularies
    end

    # Base directory of default external file store
    mattr_accessor :external_file_store

    # Base directory of external file store for multires image derivatives
    mattr_accessor :multires_image_external_file_store

    # Regexp for building external file subpath from hex digest
    mattr_accessor :external_file_subpath_regexp

    # Image server URL
    mattr_accessor :image_server_url

    # Whether permanent IDs should be automatically assigned on create
    mattr_accessor :auto_assign_permanent_ids

    mattr_accessor :permanent_id_target_url_base do
      "https://repository.lib.duke.edu/id/"
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

    # Yields an object with module configuration accessors
    def self.configure
      yield self
    end

    def self.external_file_subpath_pattern= (pattern)
      unless /^-{1,2}(\/-{1,2}){0,3}$/ =~ pattern
        raise "Invalid external file subpath pattern: #{pattern}"
      end
      re = pattern.split("/").map { |x| "(\\h{#{x.length}})" }.join("")
      self.external_file_subpath_regexp = Regexp.new("^#{re}")
    end

  end
end

ActiveFedora::Predicates.set_predicates(Ddr::Metadata::PREDICATES)

Dir[Ddr::Models::Engine.root.to_s + "/app/models/*.rb"].each { |m| require m }
