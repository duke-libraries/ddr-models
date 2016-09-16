module Ddr
  module Auth
    class CollectionAbilityDefinitions < AbilityDefinitions

      def call
        if member_of? Ddr::Auth.collection_creators_group
          can :create, ::Collection
        end
        can :export, ::Collection do |obj|
          has_policy_permission?(obj, Permissions::READ)
        end
      end

      private

      def policy_permissions(obj)
        obj.roles
          .in_policy_scope
          .agent(agents)
          .permissions
      end

      def has_policy_permission?(obj, perm)
        policy_permissions(obj).include?(perm)
      end

    end
  end
end
