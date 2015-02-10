module Ddr
  module Auth
    extend ActiveSupport::Autoload

    autoload :User
    autoload :Superuser
    autoload :Ability
    autoload :GroupService
    autoload :GrouperService
    autoload :RemoteGroupService
    autoload :FailureApp

    # Group authorized to act as superuser
    mattr_accessor :superuser_group

    # Group authorized to create Collections
    mattr_accessor :collection_creators_group

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

    # Name of group of which everyone (including anonymous users) is a member
    mattr_accessor :everyone_group do
      "public"
    end

    # Group of authenticated users
    mattr_accessor :authenticated_users_group do
      "registered"
    end

    # Whether to require Shibboleth authentication 
    mattr_accessor :require_shib_user_authn do
      false
    end

    mattr_accessor :sso_logout_url do
      "/Shibboleth.sso/Logout?return=https://shib.oit.duke.edu/cgi-bin/logout.pl"
    end

  end
end
