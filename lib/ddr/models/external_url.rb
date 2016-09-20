require "active_resource"

module Ddr::Models
  class ExternalUrl < ActiveResource::Base

    self.site = ENV["DDR_AUX_API_URL"]

    def self.call(url)
      new get(:find, url: url)
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
