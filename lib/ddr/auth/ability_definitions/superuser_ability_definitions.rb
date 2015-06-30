module Ddr::Auth
  class SuperuserAbilityDefinitions < AbilityDefinitions

    def call
      can :manage, :all
    end

  end
end
