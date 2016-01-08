require "delegate"

module Ddr::Auth
  class EffectiveRoles < SimpleDelegator

    def self.call(obj, agents)
      new(obj).call(agents)
    end

    def call(agents)
      ResourceRoles.call(self)
        .merge(InheritedRoles.call(self))
        .agent(agents)
        .result
    end

  end
end
