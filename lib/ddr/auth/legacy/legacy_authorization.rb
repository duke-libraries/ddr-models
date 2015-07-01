require "delegate"

module Ddr::Auth
  class LegacyAuthorization < SimpleDelegator

    def to_roles
      sources.map(&:to_roles).reduce(&:merge)
    end

    def clear
      sources.each(&:clear)
    end

    def clear?
      sources.all? { |auth| auth.source.empty? }
    end

    def migrate
      migrated = inspect
      roles.grant *to_roles
      clear
      ["LEGACY AUTHORIZATION DATA", migrated, "ROLES", roles.serialize.inspect].join("\n\n")
    end

    def inspect
      sources.map { |auth| auth.inspect }.join("\n")
    end

    private

    def sources
      wrappers.map { |wrapper| wrapper.new(self) }
    end

    def wrappers
      classes = [ LegacyPermissions, LegacyRoles ]
      if respond_to? :default_permissions
        classes << LegacyDefaultPermissions
      end
      classes
    end

  end
end
