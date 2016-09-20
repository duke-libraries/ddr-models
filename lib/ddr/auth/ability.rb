module Ddr
  module Auth
    class Ability < AbstractAbility

      self.ability_definitions = [ AliasAbilityDefinitions,
                                   CollectionAbilityDefinitions,
                                   ItemAbilityDefinitions,
                                   ComponentAbilityDefinitions,
                                   AttachmentAbilityDefinitions,
                                   RoleBasedAbilityDefinitions,
                                   DatastreamAbilityDefinitions,
                                   EventAbilityDefinitions,
                                   PublicationAbilityDefinitions,
                                   LockAbilityDefinitions,
                                   AdminSetAbilityDefinitions,
                                 ]

    end
  end
end
