require "rdf/isomorphic"

module Ddr
  module Auth
    module Roles
      #
      # An abstract class representing the assignment of a role to
      # an agent within a scope.
      #
      # @abstract
      #
      class Role < ActiveTriples::Resource

        AGENT_TYPES = [:person, :group, :agent]

        include RDF::Isomorphic

        property :agent, predicate: Ddr::Vocab::Roles.agent
        property :scope, predicate: Ddr::Vocab::Roles.scope

        validates_presence_of :agent, :scope

        class << self

          attr_accessor :permissions

          def has_permission(*permissions)
            self.permissions += permissions.map { |p| Ddr::Auth::Permission.get(p) }
          end

          # Builds a new role object from the hash arguments
          # @param args [Hash] a hash of options
          # @return [Ddr::Auth::Roles::Role]
          def build(args={})
            new.tap do |role| 
              agent_key = AGENT_TYPES.detect { |k| args.key?(k) }
              agent_class = Ddr::Auth.get_agent_class(agent_key)
              role.agent = agent_class.build(args[agent_key])
              role.scope = args.fetch(:scope, Scopes::DEFAULT)
              # validate!
            end
          end

          # Return the role "type" (not RDF type) -- i.e., a symbol for the role class
          #   This should be the inverse operation of Ddr::Auth::Roles.get_role_class(type)
          # @example Ddr::Auth::Roles::Curator.role_type => :curator
          # @return [Symbol] the role type
          def role_type
            @role_type ||= self.name.split("::").last.underscore.to_sym
          end

          def inherited(subclass)            
            subclass.permissions = []
          end

        end

        # Roles are considered equivalent if the RDF graphs are isomorphic
        # -- i.e., if the RDF type, Agent name, scope are all equal.
        # @return [Boolean] the result
        def ==(other)
          isomorphic_with? other
        end

        def to_s
          to_h.to_s
        end

        def inspect
          "#<#{self.class.name} agent=#{agent.first.to_h.inspect}, scope=#{scope.first.inspect}>"
        end

        # @see .role_type
        def role_type
          self.class.role_type
        end

        # Return the agent name associated with the role
        # @return [String, nil] the agent name, or nil if there is no agent
        def agent_name
          if ag = get_agent
            ag.agent_name
          end
        end

        # Return the agent type associated with the role
        # @return [Symbol, nil] the agent type, or nil if there is no agent
        def agent_type
          if ag = get_agent
            ag.agent_type
          end
        end

        def person_agent?
          agent_type == :person
        end

        def group_agent?
          agent_type == :group
        end

        def to_h
          val = { 
            type: role_type,
            scope: scope.first
          }
          if agent.present?
            val[agent_type] = agent_name 
          end
          val
        end
        alias_method :to_hash, :to_h
        
        # @see .permissions
        def permissions
          self.class.permissions
        end

        def get_agent
          if agent.present?
            agent.first
          end
        end

      end

    end
  end
end
