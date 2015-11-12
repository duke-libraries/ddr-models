require "virtus"

module Ddr::Auth
  module Roles
    class RoleAttribute < Virtus::Attribute

      def coerce(value)
        value.to_s
      end

    end
  end
end
