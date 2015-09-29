require "ddr_aux/client"

module Ddr::Models
  class License < DdrAux::Client::License

    attr_accessor :pid

    def self.call(obj)
      if obj.license
        license = find(url: obj.license)
        license.pid = obj.pid
        license
      end
    end

    def to_s
      title
    end

  end
end
