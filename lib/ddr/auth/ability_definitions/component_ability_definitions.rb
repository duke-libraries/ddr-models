module Ddr
  module Auth
    class ComponentAbilityDefinitions < AbilityDefinitions

      def call
        can :create, ::Component do |obj|
          obj.parent.present? && can?(:add_children, obj.parent)
        end
      end

    end
  end
end
