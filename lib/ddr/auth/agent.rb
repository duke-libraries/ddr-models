require "rdf/isomorphic"

module Ddr
  module Auth
    #
    # The agent (person or group) to whom a role is granted.
    #
    class Agent < ActiveTriples::Resource

      TYPES = {
        person: RDF::FOAF.Person,
        group: RDF::FOAF.Group
      }

      RDF_TYPES = TYPES.invert

      NAME_PATTERNS = {
        person: Regexp.new('\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\z'),
        group:  Regexp.new('\A[\w.:\-]+\z')
      }

      include Hydra::Validations
      include RDF::Isomorphic

      configure type: RDF::FOAF.Agent
      property :name, predicate: RDF::FOAF.name

      validates_inclusion_of :type, in: RDF_TYPES.keys
      validates_presence_of :name
      validate :name_matches_pattern_for_type

      class << self

        def build(opts={})
          new.tap do |agent|
            agent.type = TYPES.fetch(opts[:type])
            agent.name = opts[:name].to_s
            if agent.invalid?
              raise Ddr::Models::Error, "Invalid #{self.name}: #{agent.errors.full_messages.inspect}"
            end
          end
        end

        TYPES.each_key do |agent_type|
          define_method agent_type do |name|
            build(type: agent_type, name: name)
          end
        end

      end

      # Agents are considered equal if their names (and types) are equal
      def ==(other)
        isomorphic_with? other
      end

      def to_s
        agent_name
      end

      def to_h
        {type: agent_type, name: agent_name}
      end

      def inspect
        "#<#{self.class.name} type=#{agent_type.inspect}, name=#{agent_name.inspect}>"
      end

      def agent_name
        name.first
      end

      # @example
      # rdf_type   => RDF::FOAF.Person
      # agent_type => :person
      def agent_type
        RDF_TYPES[rdf_type]
      end

      def rdf_type
        type.first
      end

      protected

      def name_pattern
        NAME_PATTERNS[agent_type]
      end

      def name_matches_pattern_for_type
        if agent_name !~ name_pattern
          errors.add(:name, :invalid)
        end
      end

    end
  end
end
