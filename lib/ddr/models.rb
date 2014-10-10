require 'active_fedora'
require 'hydra-core'
require 'hydra-access-controls'
require 'hydra/validations'
require "ddr/models/version"
require "ddr/datastreams"
require 'ddr/index_fields'
require "ddr/metadata"

module Ddr
  module Models
    extend ActiveSupport::Autoload

    autoload :Base
    autoload :Describable
    autoload :AccessControllable
    # autoload :Governable
    autoload :HasProperties
    autoload :HasThumbnail
    autoload :Indexing

    require 'ddr/models/collection'
    #require 'ddr/models/item'
    #require 'ddr/models/component'

  end
end