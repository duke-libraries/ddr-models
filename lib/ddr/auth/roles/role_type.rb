module Ddr
  module Auth
    module Roles
      class RoleType

        attr_reader :title, :description, :permissions
        alias_method :label, :title

        def initialize(title, description, permissions)
          @title = title.freeze
          @description = description.freeze
          @permissions = permissions.freeze
          freeze
        end

        def to_s
          title
        end
        # alias_method :to_str, :to_s

      end
    end
  end
end
