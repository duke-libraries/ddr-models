module Ddr
  module Auth
    class AttachmentAbilityDefinitions < AbilityDefinitions

      def call
        can :create, ::Attachment do |obj|
          obj.attached_to.present? && can?(:add_attachment, obj.attached_to)
        end
      end

    end
  end
end
