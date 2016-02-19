module Ddr
  module Auth
    class PublicationAbilityDefinitions < AbilityDefinitions

      def call
        can :publish, Ddr::Models::Base do |obj|
          !obj.published? && obj.publishable?
        end
        can :unpublish, Ddr::Models::Base do |obj|
          obj.published?
        end
      end

    end
  end
end
