module Ddr
  module Auth
    class ItemAbilityDefinitions < AbilityDefinitions

      def call
        can :create, ::Item do |obj|
          obj.parent.present? && can?(:add_children, obj.parent)
        end
      end

    end
  end
end
