require "delegate"

module Ddr::Auth
  class LegacyRoles < SimpleDelegator

    def to_roles
      adminMetadata.downloader.each_with_object(Roles::DetachedRoleSet.new) do |agent, memo|
        memo.grant Roles::Role.build(type: Roles::DOWNLOADER, agent: agent, scope: Roles::RESOURCE_SCOPE)
      end
    end

  end
end
