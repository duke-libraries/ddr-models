require "ostruct"
require "ddr_aux/client"

module Ddr::Models
  class License < SimpleDelegator

    class << self
      def get(url)
        licenses = DdrAux::Client.licenses(url: url)
        licenses.first && new(licenses.first)
      end

      def all
        DdrAux::Client.licenses.map { |l| new(l) }
      end

      def call(obj)
        if obj.license
          l = get obj.license
          l[:licensed] = obj.pid
          l
        end
      end
    end

    def initialize(args={})
      super OpenStruct.new(args)
    end

    def to_json
      to_h.to_json
    end

    def ==(other)
      other.is_a?(self.class) && other.__getobj__ == __getobj__
    end

  end
end
