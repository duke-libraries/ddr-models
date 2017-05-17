require "active_resource"

module Ddr::Models
  class Language < ActiveResource::Base

    self.site = ENV["DDR_AUX_API_URL"]

    def self.call(obj)
      obj.language.map do |lang|
        find_by_code(lang)
      end
    rescue ActiveResource::ResourceNotFound => e
      raise Ddr::Models::NotFoundError, e
    end

    def self.find_by_code(code)
      return unless code
      new get(:find, code: code)
    end

    def self.codes
      all.map(&:code)
    end

    def to_s
      label
    end

  end
end

