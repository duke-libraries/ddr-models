module Ddr::Auth
  #
  # RoleSet query interface
  #
  # @api private
  #
  class RoleSetQuery
    include Enumerable

    attr_reader :criteria, :role_set

    delegate :each, :agents, :permissions, :empty?, to: :result

    def initialize(role_set)
      @role_set = role_set
      @criteria = {}
    end

    def where(conditions={})
      criteria.merge!(conditions)
      self
    end

    def scope(s)
      where(scope: s)
    end

    def in_policy_scope
      scope(Roles::POLICY_SCOPE)
    end

    def in_resource_scope
      scope(Roles::RESOURCE_SCOPE)
    end

    def agent(a)
      where(agent: a)
    end
    alias_method :group, :agent

    def role_type(r)
      where(role_type: r)
    end
    alias_method :type, :role_type

    def merge(other_query)
      where(other_query.criteria)
    end

    def result
      matching_roles = role_set.select { |role| matches_all?(role) }
      RoleSet.new(roles: matching_roles)
    end

    private

    # Return a list of the permissions granted to any of the agents in the given scope
    def permissions_for_agents_in_scope(agents, scope)
      agent(agents).scope(scope).permissions
    end

    def matches_all?(role)
      criteria.all? { |key, value| matches_one?(role, key, value) }
    end

    def matches_one?(role, key, value)
      Array(value).include? role.send(key)
    end

  end
end
