require "delegate"

module Ddr::Auth
  class LegacyRoles < SimpleDelegator

    def source
      adminMetadata.downloader
    end

    def to_roles
      source.each_with_object(Roles::DetachedRoleSet.new) do |agent, memo|
        memo.grant Roles::Role.build(type: Roles::DOWNLOADER, agent: agent, scope: Roles::RESOURCE_SCOPE)
      end
    end

    def clear
      source.clear
    end

    def inspect
      "DOWNLOADER: #{source.inspect}"
    end

  end
end
