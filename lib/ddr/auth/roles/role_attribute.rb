require "virtus"

module Ddr::Auth
  module Roles
    class RoleAttribute < Virtus::Attribute

      def coerce(value)
        if value.is_a? Array
          return coerce(value.first)
        end
        value.to_s
      end

    end
  end
end
