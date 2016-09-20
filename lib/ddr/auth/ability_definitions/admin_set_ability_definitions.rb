module Ddr::Auth
  class AdminSetAbilityDefinitions < AbilityDefinitions

    def call
      can :export, Ddr::Models::AdminSet if metadata_manager?
    end

  end
end
