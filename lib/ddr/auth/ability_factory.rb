module Ddr::Auth
  class AbilityFactory

    private_class_method :new

    def self.call(user = nil, env = nil)
      new(user, env).call
    end

    attr_reader :auth_context

    delegate :anonymous?, :superuser?, to: :auth_context
    
    def initialize(user, env)
      @auth_context = AuthContextFactory.call(user, env)
    end

    def call
      if anonymous?
        AnonymousAbility.new(auth_context)
      elsif superuser?
        SuperuserAbility.new(auth_context)
      else
        default_ability.new(auth_context)
      end
    end

    def default_ability
      Ddr::Auth::default_ability.constantize
    end

  end
end
