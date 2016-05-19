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
      autoload :LockAbilityDefinitions
      autoload :PublicationAbilityDefinitions
      autoload :RoleBasedAbilityDefinitions
      autoload :SuperuserAbilityDefinitions
    end

    autoload_under 'roles' do
      autoload :Role
      autoload :RoleAttribute
      autoload :RoleSet
      autoload :RoleSetManager
      autoload :RoleSetQuery
      autoload :RoleType
      autoload :RoleTypes
      autoload :RoleValidator
    end

    # Name of group whose members are authorized to act as superuser
    mattr_accessor :superuser_group

    # Name of group whose members are authorized to create Collections
    mattr_accessor :collection_creators_group

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

    def self.repository_group_filter
      if filter = ENV["REPOSITORY_GROUP_FILTER"]
        return filter
      end
      raise Ddr::Models::Error, "The \"REPOSITORY_GROUP_FILTER\" environment variable is not set."
    end

  end
end
