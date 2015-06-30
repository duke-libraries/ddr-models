require "net-ldap"

module Ddr::Auth
  class LdapGateway

    SCOPE = Net::LDAP::SearchScope_SingleLevel

    class_attribute :attributes
    self.attributes = [ "edupersonaffiliation", "ismemberof" ]

    attr_reader :ldap

    def self.find(user_key)
      new.find(user_key)
    end

    def initialize
      @ldap = Net::LDAP.new(config)
    end

    def find(user_key)
      result_set = ldap.search find_params(user_key)
      if result_set
        Result.new result_set.first
      else
        raise ldap.get_operation_result.message
      end
    end

    class Result
      attr_reader :result

      def initialize(result)
        @result = result
      end

      def affiliation
        result ? result[:edupersonaffiliation] : []
      end

      def ismemberof
        result ? result[:ismemberof] : []
      end
    end

    private

    def find_params(user_key)
      { scope: SCOPE,
        filter: filter(user_key),
        size: 1,
        attributes: attributes
      }
    end

    def filter(user_key)
      Net::LDAP::Filter.eq("eduPersonPrincipalName", user_key)
    end

    def config
      { host: ENV["LDAP_HOST"],
        port: ENV["LDAP_PORT"],
        base: ENV["LDAP_BASE"],
        auth:
          { method: :simple,
            username: ENV["LDAP_USER"],
            password: ENV["LDAP_PASSWORD"]
          },
        encryption: { method: :simple_tls }
      }
    end

  end
end
