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
    autoload :Person
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
      warn "DEPRECATION WARNING: `Ddr::Auth.everyone_group` is deprecated; use `Ddr::Auth::Groups::Public`."
      Groups::Public
    end

    # Group of authenticated users
    def self.authenticated_users_group
      warn "DEPRECATION WARNING: `Ddr::Auth.authenticated_users_group` is deprecated; use `Ddr::Auth::Groups::Registered`."
      Groups::Registered
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

    def self.get_agent_class(agent_type)
      agent_class = const_get(agent_type.to_s.camelize)
      unless agent_class < Agent || agent_class === Agent
        raise ArgumentError, "#{agent_type.inspect} is not a valid agent type."
      end
      agent_class
    end

  end
end
