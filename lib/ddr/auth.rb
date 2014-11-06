module Ddr
  module Auth
    extend ActiveSupport::Autoload

    autoload :User
    autoload :Superuser
    autoload :Ability
    autoload :GroupService
    autoload :GrouperService
    autoload :RemoteGroupService

    # Superuser group
    mattr_accessor :superuser_group

    ## Remote groups (i.e., Grouper) config settings
    # request.env key for group memberships
    mattr_accessor :remote_groups_env_key do
      "ismemberof"
    end

    # request.env value internal delimiter
    mattr_accessor :remote_groups_env_value_delim do
      ";"
    end

    # pattern/repl for converting request.env membership values to proper (Grouper) group names
    mattr_accessor :remote_groups_env_value_sub do
      [/^urn:mace:duke\.edu:groups/, "duke"]
    end

    # Filter for getting list of remote groups for the repository - String, not Regexp
    mattr_accessor :remote_groups_name_filter do
      "duke:library:repository:ddr:"
    end

    mattr_accessor :everyone_group do
      "public"
    end

    mattr_accessor :authenticated_users_group do
      "registered"
    end

  end
end
