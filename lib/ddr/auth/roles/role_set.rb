module Ddr::Auth
  module Roles
    #
    # Wraps a set of Roles
    #
    # @abstract
    #
    class RoleSet
      include Enumerable

      attr_reader :role_set

      delegate :where, :agent, :scope, :role_type, :type, :agents, :permissions,
               :in_policy_scope, :in_resource_scope,
               to: :query

      delegate :empty?, :clear, to: :role_set

      def initialize(role_set)
        @role_set = role_set
      end

      def granted
        warn "[DEPRECATION] `granted` is deprecated." \
             " Use the RoleSet object directly (#{caller.first})."
        self
      end

      # Grants roles - i.e., adds them to the role set
      # @example - default scope ("resource")
      #   grant type: "Curator", agent: "bob"
      # @example - explicit scope
      #   grant type: "Curator", agent: "sue", scope: "policy"
      # @param roles [Role, Hash, RoleSet, Array] the role(s) to grant
      def grant(*roles)
        raise NotImplementedError, "Subclasses must implement `grant`."
      end

      # Return true/false depending on whether the role has been granted
      # @param role [Ddr::Auth::Roles::Role, Hash] the role
      # @return [Boolean] whether the role has been granted
      def granted?(role)
        include? coerce(role)
      end

      # Revokes roles - i.e., removes them from the role set
      # @example
      #   revoke type: "Curator", agent: "bob", scope: "resource"
      # @param roles [Role, Hash, RoleSet, Array] the role(s) to revoke
      def revoke(*roles)
        raise NotImplementedError, "Subclasses must implement `revoke`."
      end

      # Replace the current roles in the role set with new roles
      # @param roles [Role, Hash, RoleSet, Array] the role(s) to grant
      def replace(*roles)
        revoke_all
        grant(*roles)
      end

      # Remove all roles from the role set
      # @return [RoleSet] self
      def revoke_all
        raise NotImplementedError, "Subclasses must implement `revoke_all`."
      end

      # Return the RoleSet serialized as JSON
      # @return [String] the JSON string
      def to_json
        serialize.to_json
      end

      # Return the RoleSet serialized as an Array of serialized Roles
      # @return [Array<Hash>]
      def serialize
        to_a.map(&:serialize)
      end

      def ==(other)
        if other.is_a? RoleSet
          self.to_set == other.to_set
        else
          super
        end
      end

      private

      def query
        RoleSetQuery.new(self)
      end

      def coerce(obj)
        case obj
        when RoleSet
          coerce(obj.role_set)
        when Array, Set
          obj.map { |r| coerce(r) }.flatten
        when Role
          obj
        else
          Role.build(obj)
        end
      end

    end
  end
end
