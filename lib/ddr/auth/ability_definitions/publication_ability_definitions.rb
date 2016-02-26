module Ddr
  module Auth
    class PublicationAbilityDefinitions < AbilityDefinitions

      def call
        cannot :publish, Ddr::Models::Base do |obj|
          obj.published? || !obj.publishable?
        end
        cannot :unpublish, Ddr::Models::Base do |obj|
          !obj.published?
        end
      end

    end
  end
end
