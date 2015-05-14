require "delegate"

module Ddr::Auth
  class EffectiveRoles < SimpleDelegator

    # @param obj [Object] an object that receives :roles and returns a RoleSet
    # @param agents [String, Array<String>] agent(s) to match roles
    # @return [Ddr::Auth::Roles::RoleSetQuery]
    def self.call(obj, agents)
      new(obj).call(agents)
    end

    # @param agents [String, Array<String>] agent(s) to match roles
    # @return [Ddr::Auth::Roles::RoleSetQuery]
    def call(agents)
      ResourceRoles.call(self)
        .merge(InheritedRoles.call(self))
        .agent(agents)
    end

  end
end
