require "delegate"

module Ddr
  module Auth
    #
    # A class which applies ability definitions to the delegated ability class
    # when `#call` is invoked.
    #
    # @abstract
    #
    class AbilityDefinitions < SimpleDelegator

      # Applies ability definitions to the ability and return it
      def self.call(ability)
        new(ability).call
        ability
      end

      # Applies abilities definitions with `can` and `cannot`.
      def call
        raise NotImplementedError, "Subclasses must implement `#call`."
      end

    end
  end
end
