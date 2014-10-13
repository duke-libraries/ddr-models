require 'active_record'
require 'active_fedora'
require 'hydra-core'
require 'hydra-access-controls'
require 'hydra/derivatives'
require 'hydra/validations'
require 'ddr/models/engine'
require 'ddr/models/version'
require 'ddr/actions'
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
    autoload :HasThumbnail
    autoload :Indexing
    autoload :FileManagement
    autoload :Licensable
    autoload :MintedId
    autoload :PermanentIdentification
    
    # require 'ddr/models/collection'
    #require 'ddr/models/item'
    #require 'ddr/models/component'

    include Ddr::Configurable

  end
end