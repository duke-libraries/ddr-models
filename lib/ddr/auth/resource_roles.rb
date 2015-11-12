require "delegate"

module Ddr::Auth
  class ResourceRoles < SimpleDelegator

    def self.call(obj)
      new(obj).call
    end

    def call
      roles.in_resource_scope.result
    end

  end
end
