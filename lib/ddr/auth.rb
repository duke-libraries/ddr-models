module Ddr
  module Auth
    extend ActiveSupport::Autoload

    autoload :Ability
    autoload :Affiliation
    autoload :Agent
    autoload :FailureApp
    autoload :Group
    autoload :GrouperGateway
    autoload :Groups
    autoload :LdapGateway
    autoload :LegacyPermissions
    autoload :LegacyRoles
    autoload :Permission
    autoload :RoleBasedAccessControlsEnforcement
    autoload :Roles
    autoload :Superuser
    autoload :User

    # Name of group whose members are authorized to act as superuser
    mattr_accessor :superuser_group

    # Name of group whose members are authorized to create Collections
    mattr_accessor :collection_creators_group

    # Group of which everyone (including anonymous users) is a member
    def self.everyone_group
      warn "DEPRECATION WARNING: `Ddr::Auth.everyone_group` is deprecated; use `Ddr::Auth::Groups::PUBLIC`."
      Groups::PUBLIC
    end

    # Group of authenticated users
    def self.authenticated_users_group
      warn "DEPRECATION WARNING: `Ddr::Auth.authenticated_users_group` is deprecated; use `Ddr::Auth::Groups::REGISTERED`."
      Groups::REGISTERED
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
