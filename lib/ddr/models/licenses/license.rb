require "active_resource"

module Ddr::Models
  class License < ActiveResource::Base

    self.site = ENV["DDR_AUX_API_URL"]

    attr_accessor :pid

    def self.call(obj)
      if obj.license
        license = new get(:find, url: obj.license)
        license.pid = obj.pid
        license
      end
    rescue ActiveResource::ResourceNotFound => e
      raise Ddr::Models::NotFoundError, e
    end

    def to_s
      title
    end

  end
end
