module Ddr
  module Auth
    class CollectionAbilityDefinitions < AbilityDefinitions

      def call
        if member_of? Ddr::Auth.collection_creators_group
          can :create, ::Collection
        end
        alias_action :ingest_metadata, to: :update
      end

    end
  end
end
