require "active_resource"

module Ddr::Models
  class Contact < ActiveResource::Base

    self.site = ENV["DDR_AUX_API_URL"]

    def self.call(slug)
      new get(:find, slug: slug)
    rescue ActiveResource::ResourceNotFound => e
      raise Ddr::Models::NotFoundError, e
    end

    def self.keys
      all.map(&:slug)
    end

    def to_s
      name
    end

  end
end
