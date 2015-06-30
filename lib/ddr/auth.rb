module Ddr
  module Auth
    extend ActiveSupport::Autoload

    autoload :Ability
    autoload :AbilityDefinitions
    autoload :AbilityFactory
    autoload :AbstractAbility
    autoload :Affiliation
    autoload :AffiliationGroups
    autoload :AnonymousAbility
    autoload :AuthContext
    autoload :AuthContextFactory
    autoload :DetachedAuthContext
    autoload :DynamicGroups
    autoload :EffectivePermissions
    autoload :EffectiveRoles
    autoload :FailureApp
    autoload :Group
    autoload :GrouperGateway
    autoload :Groups
    autoload :InheritedRoles
    autoload :LdapGateway
    autoload :LegacyPermissions
    autoload :LegacyRoles
    autoload :Permissions
    autoload :RemoteGroups
    autoload :ResourceRoles
    autoload :RoleBasedAccessControlsEnforcement
    autoload :Roles
    autoload :SuperuserAbility
    autoload :User
    autoload :WebAuthContext

    autoload_under 'ability_definitions' do
      autoload :AliasAbilityDefinitions
      autoload :AttachmentAbilityDefinitions
      autoload :CollectionAbilityDefinitions
      autoload :ComponentAbilityDefinitions
      autoload :DatastreamAbilityDefinitions
      autoload :EventAbilityDefinitions
      autoload :ItemAbilityDefinitions
      autoload :RoleBasedAbilityDefinitions
      autoload :SuperuserAbilityDefinitions
    end

    # Name of group whose members are authorized to act as superuser
    mattr_accessor :superuser_group

    # Name of group whose members are authorized to create Collections
    mattr_accessor :collection_creators_group

    # Group of which everyone (including anonymous users) is a member
    def self.everyone_group
      warn "[DEPRECATION] `Ddr::Auth.everyone_group` is deprecated." \
           " Use `Ddr::Auth::Groups::PUBLIC` instead."
      Groups::PUBLIC
    end

    # Group of authenticated users
    def self.authenticated_users_group
      warn "[DEPRECATION] `Ddr::Auth.authenticated_users_group` is deprecated." \
           " Use `Ddr::Auth::Groups::REGISTERED` instead."
      Groups::REGISTERED
    end

    def self.const_missing(name)
      if name == :Superuser
        warn "[DEPRECATION] `Ddr::Auth::Superuser` is deprecated." \
             " Use `Ddr::Auth::SuperuserAbility` instead."
        return SuperuserAbility
      end
      super
    end

    # Whether to require Shibboleth authentication
    mattr_accessor :require_shib_user_authn do
      false
    end

    mattr_accessor :sso_logout_url do
      "/Shibboleth.sso/Logout?return=https://shib.oit.duke.edu/cgi-bin/logout.pl"
    end

    # Grouper gateway implementation
    mattr_accessor :grouper_gateway do
      GrouperGateway
    end

    # LDAP gateway implementation
    mattr_accessor :ldap_gateway do
      LdapGateway
    end

    mattr_accessor :default_ability do
      "::Ability"
    end

  end
end
