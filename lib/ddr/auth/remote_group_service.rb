module Ddr
  module Auth
    class RemoteGroupService < GroupService

      attr_reader :env

      def initialize(env = nil)
        @env = env
      end

      def append_groups
        GrouperService.repository_group_names
      end

      def append_user_groups(user)
        if env && env.key?(Ddr::Auth.remote_groups_env_key)
          remote_groups
        else
          GrouperService.user_group_names(user)
        end
      end

      def remote_groups
        # get the raw list of values
        groups = env[Ddr::Auth.remote_groups_env_key].split(Ddr::Auth.remote_groups_env_value_delim)
        # munge values to proper Grouper group names, if necessary
        groups = groups.collect { |g| g.sub(*Ddr::Auth.remote_groups_env_value_sub) } if Ddr::Auth.remote_groups_env_value_sub
        # filter group list as configured
        groups = groups.select { |g| g =~ /^#{Ddr::Auth.remote_groups_name_filter}/ } if Ddr::Auth.remote_groups_name_filter
        groups
      end

    end
  end
end
