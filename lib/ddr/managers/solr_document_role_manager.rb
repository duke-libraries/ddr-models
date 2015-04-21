module Ddr
  module Managers
    class SolrDocumentRoleManager < AbstractRoleManager

      def granted
        @granted ||= Ddr::Auth::Roles::RoleSet.deserialize(object.access_role, :json)
      end

    end
  end
end
