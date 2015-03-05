module Ddr
  module Auth
    extend ActiveSupport::Autoload

    autoload :User
    autoload :Superuser
    autoload :Ability
    autoload :Groups
    autoload :GrouperGateway
    autoload :FailureApp
    autoload :LdapGateway

    # Group authorized to act as superuser
    mattr_accessor :superuser_group

    # Group authorized to create Collections
    mattr_accessor :collection_creators_group

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

    mattr_accessor :grouper_gateway do
      GrouperGateway
    end

    mattr_accessor :ldap_gateway do
      LdapGateway
    end

  end
end
