module Ddr
  module Auth
    class HydraPermission

      attr_reader :perm

      PERMISSION_ROLE_MAP = {
        "discover" => :viewer,
        "read" => :viewer,
        "edit" => :editor
      }
      
      def initialize(perm)
        @perm = perm
      end
      
      def to_role(scope = nil)
        args = {}
        args[:type] = PERMISSION_ROLE_MAP[perm[:access]]
        agent_key = (perm[:type] == "group" ? :group : :person)
        args[agent_key] = perm[:name]
        args[:scope] = scope
        Roles.build_role(args)          
      end

    end
  end
end
