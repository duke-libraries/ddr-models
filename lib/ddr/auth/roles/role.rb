require "json"
require "virtus"

module Ddr::Auth
  module Roles
    #
    # The assignment of a role to an agent within a scope.
    #
    class Role
      extend Deprecation
      include Virtus.value_object
      include Ddr::Models::Validatable

      self.validator = RoleValidator

      DEFAULT_SCOPE = Roles::RESOURCE_SCOPE

      values do
        attribute :agent,     RoleAttribute
        attribute :role_type, RoleAttribute
        attribute :scope,     RoleAttribute, default: DEFAULT_SCOPE
      end

      class << self
        def build(*args)
          Deprecation.warn(Role, "`build` is deprecated; use `new` instead.")
          new(*args)
        end

        def from_json(json)
          new JSON.parse(json)
        end
      end

      def initialize(*args)
        super
        validate!
      end

      def to_s
        to_h.to_s
      end

      def to_json
        JSON.dump(to_h)
      end

      def validate!
        if invalid?
          raise Ddr::Models::Error, "Invalid Role: #{errors.full_messages.join('; ')}"
        end
      end

      def in_resource_scope?
        scope == Roles::RESOURCE_SCOPE
      end

      def in_policy_scope?
        scope == Roles::POLICY_SCOPE
      end

      # Returns the permissions associated with the role
      # @return [Array<Symbol>] the permissions
      def permissions
        Roles.type_map[role_type].permissions
      end

    end
  end
end
