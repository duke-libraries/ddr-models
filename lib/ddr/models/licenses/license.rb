require "ddr_aux/client"

module Ddr::Models
  class License < DdrAux::Client::License
    extend Deprecation

    attr_accessor :object_id

    def self.call(obj)
      if obj.license
        license = find(url: obj.license)
        license.object_id = obj.id
        license
      end
    end

    def pid
      Deprecation.warn(License, "Use `object_id` instead.")
      object_id
    end

    def to_s
      title
    end

  end
end
