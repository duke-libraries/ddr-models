module Ddr
  module Auth
    class LockAbilityDefinitions < AbilityDefinitions

      DENIED_WHEN_LOCKED = [ :add_children, :update, :replace, :arrange, :grant ]

      def call
        cannot DENIED_WHEN_LOCKED, Ddr::Models::Base, :locked? => true
      end

    end
  end
end
