require "rdf/isomorphic"

module Ddr
  module Auth
    module Roles
      #
      # Represents the assignment of a role to an agent within a scope.
      #
      class Role < ActiveTriples::Resource

        DEFAULT_SCOPE = Roles::RESOURCE_SCOPE

        # TYPES = {
        #   "Curator" => {
        #     permissions: [:read, :download, :add_children, :edit, :replace, :arrange, :grant].freeze
        #     }.freeze,

        #   "Editor" => {
        #     permissions: [:read, :download, :add_children, :edit, :replace, :arrange].freeze
        #     }.freeze,

        #   "MetadataEditor" => {
        #     permissions: [:read, :download, :edit].freeze
        #     }.freeze,

        #   "Contributor" => {
        #     permissions: [:read, :add_children].freeze
        #     }.freeze,

        #   "Downloader" => {
        #     permissions: [:read, :download].freeze
        #     }.freeze,

        #   "Viewer" => {
        #     permissions: [:read].freeze
        #     }.freeze

        # }.freeze

        include RDF::Isomorphic
        include Hydra::Validations

        configure type: Ddr::Vocab::Roles.Role
        property :role_type, predicate: Ddr::Vocab::Roles.type
        property :agent, predicate: Ddr::Vocab::Roles.agent
        property :scope, predicate: Ddr::Vocab::Roles.scope

        validates_presence_of :agent
        validates_inclusion_of :role_type, in: Roles.type_map.keys
        validates_inclusion_of :scope, in: Roles::SCOPES

        def self.build(args={})
          new.tap do |role| 
            role.agent     = args.fetch(:agent).to_s
            role.scope     = args.fetch(:scope, DEFAULT_SCOPE).to_s
            role.role_type = args.fetch(:type).to_s
            if role.invalid?
              raise Ddr::Models::Error, "Invalid #{self.name}: #{role.errors.full_messages.join('; ')}"
            end
          end
        end

        # Roles are considered equivalent if the RDF graphs are isomorphic
        # @return [Boolean] the result
        def ==(other)
          isomorphic_with? other
        end

        def to_s
          to_h.to_s
        end

        def inspect
          "#<#{self.class.name} type=#{role_type.first.inspect}, " \
          "agent=#{agent.first.inspect}, scope=#{scope.first.inspect}>"
        end

        def to_h
          { type: role_type.first,
            scope: scope.first,
            agent: agent.first }
        end
        alias_method :to_hash, :to_h
        
        def permissions
          Roles.type_map[role_type.first].permissions
        end

      end
    end
  end
end
