require "ddr_aux/client"

module Ddr::Models
  class AdminSet < DdrAux::Client::AdminSet

    def self.call(obj)
      if obj.admin_set
        find(code: obj.admin_set)
      end
    end

    def to_s
      title
    end

  end
end
