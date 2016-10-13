require "active_resource"

module Ddr::Models
  class AdminSet < ActiveResource::Base

    self.site = ENV["DDR_AUX_API_URL"]

    def self.call(obj)
      find_by_code(obj.admin_set)
    rescue ActiveResource::ResourceNotFound => e
      raise Ddr::Models::NotFoundError, e
    end

    def self.find_by_code(code)
      return unless code
      new get(:find, code: code)
    end

    def self.keys
      all.map(&:code)
    end

    def to_s
      title
    end

  end
end
