require "rdf/isomorphic"

module Ddr
  module Auth
    #
    # The agent (person or group) to whom a role is granted.
    # Use subclasses for concrete instances.
    #
    # @abstract
    #
    class Agent < ActiveTriples::Resource

      include RDF::Isomorphic

      configure type: RDF::FOAF.Agent
      property :name, predicate: RDF::FOAF.name

      validates_presence_of :name

      # Agents are considered equal if their names (and types) are equal
      def ==(other)
        isomorphic_with? other
      end

      def to_s
        name.first
      end

      def inspect
        "#<#{self.class.name}(#{self})>"
      end

      class << self
        # Factory method
        #   Assumes that the string representation of the object may be used as the agent's name.
        # @param obj [Object] the object from which to build the agent
        # @param force [Boolean] whether to force the instantiation of a new agent
        #   even if the obj is an agent instance (default: `false`). If false,
        #   and the object is an agent, it is simply returned.
        # @return [Agent] the agent
        def build(obj, force=false)
          if !force && obj.is_a?(self)
            return obj
          end
          new.tap do |agent| 
            agent.name = obj.to_s
            # validate! 
          end
        end
      end

    end
  end
end
