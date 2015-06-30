module Ddr
  module Auth
    class CollectionAbilityDefinitions < AbilityDefinitions

      def call
        if member_of? Groups::COLLECTION_CREATORS
          can :create, ::Collection
        end
      end

    end
  end
end
