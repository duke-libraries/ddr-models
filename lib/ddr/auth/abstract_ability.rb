module Ddr::Auth
  # @abstract
  class AbstractAbility
    include CanCan::Ability

    class_attribute :ability_definitions
    self.ability_definitions = []

    # CanCan default aliases:
    #
    #   alias_action :index, :show, :to => :read
    #   alias_action :new, :to => :create
    #   alias_action :edit, :to => :update
    #
    class_attribute :exclude_default_aliases
    self.exclude_default_aliases = false

    attr_reader :auth_context

    delegate :anonymous?, :authenticated?, :metadata_manager?,
             :user, :groups, :agents, :member_of?,
             :authorized_to_act_as_superuser?,
             to: :auth_context

    def initialize(auth_context)
      @auth_context = auth_context
      if exclude_default_aliases
        clear_aliased_actions
      end
      apply_ability_definitions
    end

    def cache
      @cache ||= {}
    end

    private

    def apply_ability_definitions
      ability_definitions.reduce(self, :apply)
    end

    def apply(ability_def)
      ability_def.call(self)
    end

  end
end
