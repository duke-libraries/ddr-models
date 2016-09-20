module Ddr::Auth
  class AbilityFactory

    def self.call(user = nil, env = nil)
      auth_context = AuthContextFactory.call(user, env)
      auth_context.ability
    end

  end
end
