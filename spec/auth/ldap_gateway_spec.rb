require "net/ldap"

module Ddr::Auth
  RSpec.describe LdapGateway do

    describe "initialization" do
      before do
        @ldap_host, @ldap_base = ENV.values_at("LDAP_HOST", "LDAP_BASE")
        ENV["LDAP_HOST"] = "ldap.example.com"
        ENV["LDAP_BASE"] = "ou=people,dc=example,dc=com" 
      end
      after do
        ENV["LDAP_HOST"] = @ldap_host
        ENV["LDAP_BASE"] = @ldap_base
      end
      its(:host) { is_expected.to eq("ldap.example.com") }
      its(:base) { is_expected.to eq("ou=people,dc=example,dc=com") }
      its(:port) { is_expected.to eq(389) }
    end

  end
end
