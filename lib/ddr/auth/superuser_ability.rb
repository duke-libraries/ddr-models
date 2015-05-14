module Ddr::Auth
  class SuperuserAbility < AbstractAbility

    self.ability_definitions = [ SuperuserAbilityDefinitions ]

  end
end
