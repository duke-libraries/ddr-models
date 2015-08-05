module Ddr::Auth
  class AnonymousAbility < AbstractAbility

    self.ability_definitions = Ability.ability_definitions.dup
    
  end
end
