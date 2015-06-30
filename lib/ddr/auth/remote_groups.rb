module Ddr::Auth
  class RemoteGroups

    # @param auth_context [AuthContext]
    # @return [Array<Group>]
    def self.call(auth_context)
      auth_context.ismemberof.map do |id|
        Group.new id.sub(/\Aurn:mace:duke\.edu:groups/, "duke")
      end
    end

  end

end
