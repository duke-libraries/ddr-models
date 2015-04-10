require "delegate"

module Ddr
  module Auth
    class Groups < SimpleDelegator

      Public     = Group.build("public")
      Registered = Group.build("registered")
      DukeEppn   = Group.build("duke.all")
      
      Superusers = Group.build("superusers")
      CollectionCreators = Group.build("collection_creators")

      ISMEMBEROF_RE = Regexp.new('urn:mace:duke\.edu:groups:library:repository:ddr:[\w:]+')
      DUKE_EPPN_RE = Regexp.new('(?=@duke\.edu)')
      AFFILIATION_RE = Regexp.new('(%{a})(?=@duke\.edu)' % {a: Affiliation::VALUES.join("|")})

      class << self
      # Return the list of all groups available for use in the repository
      # @return [Array<Group>] the groups
        def all
          Affiliation.groups + remote + [Public, Registered, DukeEppn]
        end

        def remote
          grouper.repository_group_names.map { |name| Group.build(name) }
        end

        def grouper
          Ddr::Auth.grouper_gateway.new
        end
      end

      attr_reader :env, :user

      def initialize(user, env=nil)
        @user = user
        @env = env
        groups = [ Public ] # everybody 
        if user.persisted?
          groups << Registered 
          groups << DukeEppn if duke_eppn?
          groups.concat(remote)
          groups.concat(affiliation)
        end
        super(groups)
        self << Superusers if names.include?(Ddr::Auth.superuser_group)
        self << CollectionCreators if names.include?(Ddr::Auth.collection_creators_group)
      end

      def inspect
        "#<#{self.class.name} user=\"#{user}\", env=#{env ? '[YES]' : '[NO]'}, groups=#{names.inspect}>"
      end

      def to_s
        names.to_s
      end

      # Return a list of the group names
      # @return [Array<String>] the names
      def names
        map(&:to_s)
      end

      private        

      def grouper
        self.class.grouper
      end

      def remote
        names = if env && env["ismemberof"]
                  env["ismemberof"].scan(ISMEMBEROF_RE).map { |name| name.sub(/^urn:mace:duke.edu:groups/, "duke") }
                else
                  grouper.user_group_names(user)
                end
        names.map { |name| Group.build(name) }
      end

      def duke_eppn?
        eppn = if env && env["eppn"]
                 env["eppn"]
               else
                 user.principal_name 
               end
        !!(eppn =~ DUKE_EPPN_RE)
      end

      def affiliation
        affiliations = if env && env["affiliation"]
                         env["affiliation"].scan(AFFILIATION_RE).flatten
                       else
                         ldap.affiliations(user.principal_name)
                       end
        affiliations.map { |a| Affiliation.group(a) }
      end

      def ldap
        Ddr::Auth.ldap_gateway.new
      end

    end
  end
end
