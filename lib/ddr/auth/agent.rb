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
      
      include Hydra::Validations
      include RDF::Isomorphic

      configure type: RDF::FOAF.Agent
      property :name, predicate: RDF::FOAF.name

      validates_presence_of :name

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
        "#<#{self.class.name}(#{self})>"
      end

      def agent_name
        name.first
      end

      def agent_type
        self.class.agent_type
      end

      class << self
        # Factory method
        #   Assumes that the string representation of the object may be used as the agent's name.
        # @param obj [Object] the object from which to build the agent
        # @return [Agent] the agent
        def build(obj)
          new.tap do |agent| 
            agent.name = obj.to_s
            if agent.invalid?
              raise Ddr::Models::Error, "Invalid #{self.name}: #{agent.errors.messages.inspect}"
            end
          end
        end

        def agent_type
          @agent_type ||= self.name.split("::").last.underscore.to_sym
        end
      end

    end
  end
end
