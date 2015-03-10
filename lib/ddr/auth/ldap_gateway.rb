require "net-ldap"
require "delegate"

module Ddr
  module Auth
    class LdapGateway < SimpleDelegator

      HOST = ENV["LDAP_HOST"]
      PORT = 389
      AUTH = { method: :anonymous }
      BASE = ENV["LDAP_BASE"] 
      SCOPE = Net::LDAP::SearchScope_SingleLevel

      def initialize
        super Net::LDAP.new(host: HOST, port: PORT, auth: AUTH, base: BASE)
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
        aff = if result_set
                result = result_set.first
                result ? result[:edupersonaffiliation] : []
              else # error
                Rails.logger.error get_operation_result.message
                []
              end
        aff
      end

    end
  end
end
