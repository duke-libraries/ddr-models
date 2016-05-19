require "set"
require "virtus"

module Ddr::Auth
  #
  # Wraps a set of Roles
  #
  class RoleSet
    include Virtus.model
    include Enumerable
    include ActiveModel::Serializers::JSON

    attribute :roles, Set[Role]

    delegate :where, :agent, :scope, :role_type,
             :in_policy_scope, :in_resource_scope,
             to: :query

    delegate :each, :empty?, :clear, to: :roles

    def self.from_json(json)
      new.from_json(json.present? ? json : "{}")
    end

    def ==(other)
      instance_of?(other.class) && self.roles == other.roles
    end

    def merge(other)
      self.roles += other.roles
      self
    end

    def permissions
      map(&:permissions).flatten.uniq
    end

    def agents
      map(&:agent).uniq
    end

    def query
      RoleSetQuery.new(self)
    end

  end
end
