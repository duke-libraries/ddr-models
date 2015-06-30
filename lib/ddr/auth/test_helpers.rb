module Ddr
  module Auth
    module TestHelpers

      class MockLdapGateway
        def self.find(*args); new.find(*args); end
        def find(user_key); Ddr::Auth::LdapGateway::Result.new(nil); end
      end

      class MockGrouperGateway
        def self.repository_groups(*args); new.repository_groups(*args); end
        def repository_groups(raw = false); []; end
        def self.user_groups(*args); new.user_groups(*args); end
        def user_groups(user, raw = false); []; end
      end

    end
  end
end

Ddr::Auth.ldap_gateway = Ddr::Auth::TestHelpers::MockLdapGateway
Ddr::Auth.grouper_gateway = Ddr::Auth::TestHelpers::MockGrouperGateway
