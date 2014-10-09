require 'active_fedora'
require "ddr/models/version"
require "ddr/datastreams"

module Ddr
  module Models
    extend ActiveSupport::Autoload

    autoload :Base
    autoload :Describable

    require 'ddr/models/collection'
    #require 'ddr/models/item'
    #require 'ddr/models/component'

  end
end

# Dir[File.dirname(__FILE__) + "/models/concerns/*.rb"].each { |file| require file }
#Dir[File.join(File.dirname(__FILE__), "..", "app/models/*.rb")].each { |file| require File.basename(file) }
