module Ddr::Auth
  # @abstract
  class AuthContext

    attr_reader :user, :env

    def initialize(user = nil, env = nil)
      @user = user
      @env = env
    end

    # Return whether a user is absent from the auth context.
    # @return [Boolean]
    def anonymous?
      user.nil?
    end

    # Return whether a user is present in the auth context.
    # @return [Boolean]
    def authenticated?
      !anonymous?
    end

    # Return whether context is authenticated in superuser scope.
    # @return [Boolean]
    def superuser?
      env && env.key?("warden") && env["warden"].authenticate?(scope: :superuser)
    end

    # Return the user agent for this context.
    # @return [String] or nil, if auth context is anonymous/
    def agent
      user.agent if authenticated?
    end

    # Is the authenticated agent a Duke identity?
    # @return [Boolean]
    def duke_agent?
      !!(agent =~ /@duke\.edu\z/)
    end

    # Return the list of groups for this context.
    # @return [Array<Group>]
    def groups
      @groups ||= Groups.call(self)
    end

    # Is the user associated with the auth context a member of the group?
    # @param group [Group, String] group object or group id
    # @return [Boolean]
    def member_of?(group)
      if group.is_a? Group
        groups.include? group
      else
        member_of? Group.new(group)
      end
    end

    # Is the auth context authorized to act as superuser?
    #   This is separate from whether the context is authenticated in superuser scope.
    # @return [Boolean]
    def authorized_to_act_as_superuser?
      member_of? Ddr::Auth.superuser_group
    end

    # Return the combined user and group agents for this context.
    # @return [Array<String>]
    def agents
      groups.map(&:agent).push(agent).compact
    end

    # The IP address associated with the context.
    # @return [String]
    def ip_address
      nil
    end

    # The affiliation values associated with the context.
    # @return [Array<String>]
    def affiliation
      []
    end

    # The remote group values associated with the context.
    # @return [Array<String>]
    def ismemberof
      []
    end

  end
end
