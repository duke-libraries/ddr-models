require 'ddr/models/engine'
require 'ddr/models/version'

# Awful hack to make Hydra::AccessControls::Permissions accessible
$: << Gem.loaded_specs['hydra-access-controls'].full_gem_path + "/app/models/concerns"

require 'active_record'

require 'hydra-core'
require 'hydra/validations'

require 'ddr/actions'
require 'ddr/auth'
require 'ddr/datastreams'
require 'ddr/derivatives'
require 'ddr/events'
require 'ddr/index_fields'
require 'ddr/managers'
require 'ddr/metadata'
require 'ddr/notifications'
require 'ddr/utils'
require 'ddr/vocab'

module Ddr
  module Models
    extend ActiveSupport::Autoload

    autoload :Base
    autoload :AccessControllable
    autoload :Describable
    autoload :EventLoggable
    autoload :Error
    autoload :ChecksumInvalid, 'ddr/models/error'
    autoload :DerivativeGenerationFailure, 'ddr/models/error'
    autoload :FixityCheckable
    autoload :Governable
    autoload :HasAdminMetadata
    autoload :HasAttachments
    autoload :HasChildren
    autoload :HasContent
    autoload :HasMultiresImage
    autoload :HasProperties
    autoload :HasStructMetadata
    autoload :HasThumbnail
    autoload :Indexing
    autoload :FileManagement
    autoload :Licensable
    autoload :SolrDocument

    # Base directory of default external file store
    mattr_accessor :external_file_store

    # Base directory of external file store for multires image derivatives
    mattr_accessor :multires_image_external_file_store

    # Regexp for building external file subpath from hex digest
    mattr_accessor :external_file_subpath_regexp

    # Whether permanent IDs should be automatically assigned on create
    mattr_accessor :auto_assign_permanent_ids

    mattr_accessor :permanent_id_target_url_base do
      "https://repository.lib.duke.edu/id/"
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

Dir[Ddr::Models::Engine.root.to_s + "/app/models/*.rb"].each { |m| require m }
