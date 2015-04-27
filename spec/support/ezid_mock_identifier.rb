require "ezid-client"
require "securerandom"

module Ezid
  class MockIdentifier < Identifier

    self.defaults = {}

    def reload; self; end
    def reset; self; end

    private

    def mint
      self.id = SecureRandom.hex(4)
    end

    def create; end
    def modify; end

  end
end
