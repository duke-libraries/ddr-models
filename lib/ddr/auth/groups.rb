require "delegate"

module Ddr
  module Auth
    class Groups < SimpleDelegator

      AFFILIATIONS = %w( faculty student staff affiliate alumni emeritus )
      AFFILIATION_GROUP_MAP = AFFILIATIONS.map { |a| [a, "duke.#{a}"] }.to_h

      AFFILIATION_RE = Regexp.new('(%{a})(?=@duke\.edu)' % {a: AFFILIATIONS.join("|")})
      EPPN_RE = Regexp.new('(?=@duke\.edu)')
      ISMEMBEROF_RE = Regexp.new('urn:mace:duke\.edu:groups:library:repository:ddr:[\w:]+')

      class << self
        def all
          hydra_groups + affiliation_groups + [duke_netid_group] + repository_groups
        end

        def repository_groups
          Ddr::Auth.grouper_gateway.new.repository_group_names
        end

        def affiliation_groups
          AFFILIATION_GROUP_MAP.values
        end

        def hydra_groups
          [Ddr::Auth.everyone_group, Ddr::Auth.authenticated_users_group]
        end

        def duke_netid_group
          "duke.all"
        end
      end

      attr_reader :env, :user

      def initialize(user, env=nil)
        @user = user
        @env = env
        super(calculate_groups)
      end

      def inspect
        "#<#{self.class.name} @user=#{user.inspect}, @env=#{env ? '[YES]' : '[NO]'}, groups=#{__getobj__.inspect}>"
      end

      def calculate_groups
        groups = []
        groups << self.class.duke_netid_group if duke_netid?
        groups.concat remote_groups
        groups.concat affiliation_groups
      end

      def duke_netid?
        eppn = env ? env["eppn"] : user.principal_name 
        ((eppn =~ EPPN_RE) && true) || false
      end

      def remote_groups
        env ? env_ismemberof : grouper.user_group_names(user)
      end

      def affiliation_groups
        affiliations.map { |affiliation| AFFILIATION_GROUP_MAP[affiliation] }.compact
      end

      def grouper
        @grouper ||= Ddr::Auth.grouper_gateway.new
      end

      def ldap
        @ldap ||= Ddr::Auth.ldap_gateway.new
      end

      private

      def affiliations
        env ? env_affiliations : ldap.affiliations(user.principal_name)
      end

      def env_affiliations
        env["affiliation"] ? env["affiliation"].scan(AFFILIATION_RE).flatten : []
      end

      def env_ismemberof
        groups = env["ismemberof"] ? env["ismemberof"].scan(ISMEMBEROF_RE) : []
        groups.map { |group| group.sub("urn:mace:duke.edu:groups", "duke") }
      end

    end
  end
end
