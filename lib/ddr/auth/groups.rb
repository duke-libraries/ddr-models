module Ddr
  module Auth
    module Groups

      PUBLIC = Group.new "public", label: "Public" do |auth_context|
        true
      end
      
      REGISTERED = Group.new "registered", label: "Registered Users" do |auth_context|
        auth_context.authenticated?
      end
      
      DUKE_ALL = Group.new "duke.all", label: "Duke NetIDs" do |auth_context|
        auth_context.duke_agent?
      end

      # Return the list of all groups available for use in the repository,
      #   i.e., that can be used to assert access controls.
      # @return [Array<Group>] the groups
      def self.all
        DynamicGroups::ALL + Ddr::Auth.grouper_gateway.repository_groups
      end

      # @param auth_context [AuthContext]
      # @return [Array<Group>]
      def self.call(auth_context)
        DynamicGroups.call(auth_context) + RemoteGroups.call(auth_context)
      end

    end
  end
end
