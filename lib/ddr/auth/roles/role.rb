module Ddr
  module Auth
    module Roles
      #
      # The assignment of a role to an agent within a scope.
      #
      class Role < ActiveTriples::Resource

        DEFAULT_SCOPE = Roles::RESOURCE_SCOPE

        include Hydra::Validations

        configure type: Ddr::Vocab::Roles.Role
        property :role_type, predicate: Ddr::Vocab::Roles.type
        property :agent, predicate: Ddr::Vocab::Roles.agent
        property :scope, predicate: Ddr::Vocab::Roles.scope

        validates :agent, presence: true, cardinality: { is: 1 }
        validates :role_type, inclusion: { in: Roles.type_map.keys }, cardinality: { is: 1 }
        validates :scope, inclusion: { in: Roles::SCOPES }, cardinality: { is: 1 }

        class << self

          # Build a Role instance from hash attributes
          # @param args [Hash] the attributes
          # @return [Role] the role
          # @example
          #   Role.build type: "Curator", agent: "bob", scope: "resource"
          def build(args={})
            new.tap do |role|
              role.attributes = build_attributes(args)
              if role.invalid?
                raise Ddr::Models::Error, "Invalid #{self.name}: #{role.errors.full_messages.join('; ')}"
              end
            end
          end

          alias_method :deserialize, :build

          # Deserialize a Role from JSON
          # @param json [String] the JSON string
          # @return [Role] the role
          def from_json(json)
            deserialize JSON.parse(json)
          end

          private

          def build_attributes(args={})
            # symbolize keys and stringify values
            attrs = args.each_with_object({}) do |(k, v), memo|
              memo[k.to_sym] = Array(v).first.to_s
            end
            # set default scope if necessary
            attrs[:scope] ||= DEFAULT_SCOPE
            # accept :type key for role_type attribute
            if attrs.key?(:type)
              attrs[:role_type] = attrs.delete(:type)
            end
            attrs
          end

        end

        # Roles are considered equivalent (== and eql?) if they
        # are of the same type and have the same agent and scope.
        # @param other [Object] the object of comparison
        # @return [Boolean] the result
        def ==(other)
          if self.class == other.class
            self.to_h == other.to_h
          else
            super
          end
        end

        def eql?(other)
          (self == other) && (hash == other.hash)
        end

        def hash
          to_h.hash
        end

        def to_s
          to_h.to_s
        end

        def in_resource_scope?
          scope.first == Roles::RESOURCE_SCOPE
        end

        def in_policy_scope?
          scope.first == Roles::POLICY_SCOPE
        end

        def inspect
          "#<#{self.class.name} role_type=#{role_type.first.inspect}, " \
          "agent=#{agent.first.inspect}, scope=#{scope.first.inspect}>"
        end

        def to_h
          as_json
        end
        alias_method :to_hash, :to_h
        alias_method :serialize, :to_h

        # Returns the permissions associated with the role
        # @return [Array<Symbol>] the permissions
        def permissions
          Roles.type_map[role_type.first].permissions
        end

      end
    end
  end
end
