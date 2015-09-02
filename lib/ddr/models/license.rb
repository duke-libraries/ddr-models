require "ostruct"
require "ddr_aux/api_client"

module Ddr::Models
  class License < SimpleDelegator

    def self.get(code)
      new DdrAux::ApiClient.license(code)
    end

    def initialize(args={})
      super OpenStruct.new(args)
    end

    def description
      terms
    end

    def to_json
      to_h.to_json
    end

    def ==(other)
      other.is_a?(self.class) && other.__getobj__ == __getobj__
    end

  end
end
