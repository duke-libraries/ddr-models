module Ddr
  module Auth
    module TestHelpers

      class MockLdapGateway
        def affiliations(eppn); []; end
      end

      class MockGrouperGateway
        def repository_groups; []; end
        def repository_group_names; []; end
        def user_groups(user); []; end
        def user_group_names(user); []; end
      end

    end
  end
end

Ddr::Auth.ldap_gateway = Ddr::Auth::TestHelpers::MockLdapGateway
Ddr::Auth.grouper_gateway = Ddr::Auth::TestHelpers::MockGrouperGateway
