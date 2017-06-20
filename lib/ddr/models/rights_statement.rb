require "active_resource"

module Ddr::Models
  class RightsStatement < ActiveResource::Base

    self.site = ENV["DDR_AUX_API_URL"]

    def self.call(obj)
      if obj.rights.present?
        new get(:find, url: obj.rights.first)
      end
    rescue ActiveResource::ResourceNotFound => e
      raise Ddr::Models::NotFoundError, e
    end

    def self.keys
      all.map(&:url)
    end

    def to_s
      title
    end

  end
end
