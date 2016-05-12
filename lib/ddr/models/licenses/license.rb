require "active_resource"

module Ddr::Models
  class License < ActiveResource::Base
    extend Deprecation

    self.site = ENV["DDR_AUX_API_URL"]

    attr_accessor :object_id

    def self.call(obj)
      if obj.license
        license = new get(:find, url: obj.license)
        license.object_id = obj.id
        license
      end
    rescue ActiveResource::ResourceNotFound => e
      raise Ddr::Models::NotFoundError, e
    end

    def pid
      Deprecation.warn(License, "`pid` is deprecated; use `object_id` instead.")
      object_id
    end

    def to_s
      title
    end

  end
end
