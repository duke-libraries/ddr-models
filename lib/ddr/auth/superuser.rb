module Ddr
  module Auth
    class Superuser

      include CanCan::Ability

      def initialize
        can :manage, :all
      end

    end
  end
end
