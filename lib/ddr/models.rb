require 'active_fedora'
require "ddr/models/version"

module Ddr
  module Models
    # Your code goes here...
  end
end

# Dir[File.dirname(__FILE__) + "/models/concerns/*.rb"].each { |file| require file }
Dir[File.dirname(__FILE__) + "/models/*.rb"].each { |file| require file }