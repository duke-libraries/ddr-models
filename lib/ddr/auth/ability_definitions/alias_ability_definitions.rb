module Ddr
  module Auth
    class AliasAbilityDefinitions < AbilityDefinitions

      def call
        alias_action :upload, to: :replace
        alias_action :add_attachment, to: :add_children
      end

    end
  end
end
