require "delegate"
require "yaml"

module Ddr
  module Auth
    # Wraps an Array of Group objects
    class Groups < SimpleDelegator

      PUBLIC = Group.new "public", label: "Public"
      REGISTERED = Group.new "registered", label: "Registered Users"
      DUKE_EPPN = Group.new "duke.all", label: "Duke NetIDs"
      Superusers = Group.new "superusers", label: "Superusers"
      CollectionCreators = Group.new "collection_creators", label: "Collection Creators"

      ISMEMBEROF_RE = Regexp.new('urn:mace:duke\.edu:groups:library:repository:ddr:[\w:]+')
      DUKE_EPPN_RE = Regexp.new('(?=@duke\.edu)')
      AFFILIATION_RE = Regexp.new('(%{a})(?=@duke\.edu)' % {a: Affiliation::VALUES.join("|")})

      class << self

        # Return the list of all groups available for use in the repository
        # @return [Array<Group>] the groups
        def all
          affiliation + remote + builtin
        end

        # Build a Groups instance for the user and env context (if any)
        def build(user, env=nil)
          groups = [ PUBLIC ] # everybody
          if user.persisted?
            groups << REGISTERED
            groups << DUKE_EPPN if duke_eppn?(user, env)
            groups.concat remote(user, env)
            groups.concat affiliation(user, env)
          end
          groups << Superusers if groups.include?(Ddr::Auth.superuser_group)
          groups << CollectionCreators if groups.include?(Ddr::Auth.collection_creators_group)
          new(groups)
        end

        def remote(*args)
          if args.empty?
            grouper.repository_groups
          else
            user, env = args
            if env && env["ismemberof"]
              env["ismemberof"].scan(ISMEMBEROF_RE).map do |name|
                Group.new(name.sub(/^urn:mace:duke.edu:groups/, "duke"))
              end
            else
              grouper.user_groups(user)
            end
          end
        end

        def affiliation(*args)
          if args.empty?
            Affiliation.groups
          else
            user, env = args
            affiliations =
              if env && env["affiliation"]
                env["affiliation"].scan(AFFILIATION_RE).flatten
              else
                ldap.affiliations(user.principal_name)
              end
            affiliations.map { |a| Affiliation.group(a) }
          end
        end

        def duke_eppn?(user, env)
          eppn =
            if env && env["eppn"]
              env["eppn"]
            else
              user.principal_name
            end
          !!(eppn =~ DUKE_EPPN_RE)
        end

        def builtin
          [PUBLIC, REGISTERED, DUKE_EPPN]
        end

        def grouper
          Ddr::Auth.grouper_gateway.new
        end

        def ldap
          Ddr::Auth.ldap_gateway.new
        end

      end

      private_class_method :ldap, :grouper, :remote, :affiliation, :builtin, :duke_eppn?

      def inspect
        "#<#{self.class.name} (#{self})>"
      end

      def agents
        map(&:agent)
      end

    end
  end
end
