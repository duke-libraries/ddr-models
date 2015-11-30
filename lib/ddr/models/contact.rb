require "active_resource"

module Ddr::Models
  class Contact < ActiveResource::Base

    self.site = ENV["DDR_AUX_API_URL"]

    def self.call(slug)
      get(:find, slug: slug)
    end

    def to_s
      name
    end

  end
end
