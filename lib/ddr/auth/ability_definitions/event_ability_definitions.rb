module Ddr
  module Auth
    class EventAbilityDefinitions < AbilityDefinitions

      def call
        can :read, Ddr::Events::Event do |event|
          can? :read, event.pid
        end
      end

    end
  end
end
