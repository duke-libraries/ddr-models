module Ddr::Auth
  class DynamicGroups

    ALL = ([Groups::PUBLIC, Groups::REGISTERED, Groups::DUKE_ALL] + AffiliationGroups::ALL).freeze

    # @param auth_context [AuthContext]
    # @return [Array<Group>]
    def self.call(auth_context)
      ALL.select { |group| group.has_member?(auth_context) }
    end

  end
end
