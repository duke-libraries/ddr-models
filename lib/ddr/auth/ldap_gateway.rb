require "net-ldap"
require "delegate"

module Ddr
  module Auth
    class LdapGateway < SimpleDelegator

      SCOPE = Net::LDAP::SearchScope_SingleLevel

      def initialize
        super Net::LDAP.new(config)
      end

      # Returns a list of affiliations for a principal (person)
      # @param eppn [String] the eduPersonPrincipalName value
      # @return [Array] the list of affiliations for the principal
      def affiliations(eppn)
        filter = Net::LDAP::Filter.eq("eduPersonPrincipalName", eppn)
        result_set = search(scope: SCOPE,
                        filter: filter,
                        size: 1,
                        attributes: ["eduPersonAffiliation"])
        if result_set
          result = result_set.first
          result ? result[:edupersonaffiliation] : []
        else # error
          Rails.logger.error get_operation_result.message
          []
        end
      end

      private

      def config
        { host: ENV["LDAP_HOST"],
          port: ENV["LDAP_PORT"],
          base: ENV["LDAP_BASE"]
        }
      end

    end
  end
end
