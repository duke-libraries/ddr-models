require "delegate"

module Ddr::Auth
  class LegacyAuthorization < SimpleDelegator

    def to_roles
      sources
        .map { |auth| auth.new(self).to_roles }
        .reduce(&:merge)
    end

    private

    def sources
      [ LegacyPermissions, LegacyRoles, LegacyDefaultPermissions ]
    end

  end
end
