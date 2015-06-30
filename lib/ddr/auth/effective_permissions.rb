module Ddr::Auth
  class EffectivePermissions

    # @param obj [Object] an object that receives :roles and returns a RoleSet
    # @param agents [String, Array<String>] agent(s) to match roles
    # @return [Array<Symbol>]    
    def self.call(obj, agents)
      EffectiveRoles.call(obj, agents).permissions
    end
    
  end
end
