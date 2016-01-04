require "active_resource"

module Ddr::Models
  class AdminSet < ActiveResource::Base

    self.site = ENV["DDR_AUX_API_URL"]

    def self.call(obj)
      if obj.admin_set
        new get(:find, code: obj.admin_set)
      end
    rescue ActiveResource::ResourceNotFound => e
      raise Ddr::Models::NotFoundError, e
    end

    def to_s
      title
    end

  end
end
