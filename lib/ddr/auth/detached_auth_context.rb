module Ddr::Auth
  class DetachedAuthContext < AuthContext

    def affiliation
      anonymous? ? super : ldap_result.affiliation
    end

    def ismemberof
      anonymous? ? super : ldap_result.ismemberof
    end

    private

    def ldap_result
      @ldap_result ||= Ddr::Auth.ldap_gateway.find(user.user_key)
    end

  end
end
