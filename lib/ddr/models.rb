require 'ddr/models/engine'
require 'ddr/models/version'

# Awful hack to make Hydra::AccessControls::Permissions accessible
$: << Gem.loaded_specs['hydra-access-controls'].full_gem_path + "/app/models/concerns"

require 'active_record'

require 'hydra-core'
require 'hydra/derivatives'
require 'hydra/validations'

require 'ddr/actions'
require 'ddr/auth'
require 'ddr/configurable'
require 'ddr/datastreams'
require 'ddr/events'
require 'ddr/index_fields'
require 'ddr/metadata'
require 'ddr/notifications'
require 'ddr/services'
require 'ddr/utils'

module Ddr
  module Models
    extend ActiveSupport::Autoload

    autoload :Configurable

    autoload :Base
    autoload :AccessControllable
    autoload :Describable
    autoload :EventLoggable
    autoload :Error
    autoload :ChecksumInvalid, 'ddr/models/error'
    autoload :VirusFoundError, 'ddr/models/error'
    autoload :FixityCheckable
    autoload :Governable
    autoload :HasAttachments
    autoload :HasChildren
    autoload :HasContent
    autoload :HasContentMetadata
    autoload :HasProperties
    autoload :HasRoleAssignments
    autoload :HasThumbnail
    autoload :Indexing
    autoload :FileManagement
    autoload :Licensable
    autoload :MintedId
    autoload :PermanentIdentification
    autoload :SolrDocument
    
    include Ddr::Configurable

  end
end

Dir[Ddr::Models::Engine.root.to_s + "/app/models/*.rb"].each { |m| require m }
