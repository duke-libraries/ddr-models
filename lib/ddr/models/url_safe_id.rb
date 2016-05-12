module Ddr::Models
  class UrlSafeId

    def self.call(obj)
      obj.id.gsub(/\//, "%2F")
    end

  end
end
