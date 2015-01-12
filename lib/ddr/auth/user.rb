module Ddr
  module Auth
    module User
      extend ActiveSupport::Concern

      included do
        include Blacklight::User

        has_many :events, inverse_of: :user, class_name: "Ddr::Events::Event"

        delegate :can?, :cannot?, to: :ability

        validates_uniqueness_of :username, :case_sensitive => false
        validates_format_of :email, with: /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\z/

        # TODO Remove :trackable, :validatable
        devise :remote_user_authenticatable, :database_authenticatable, :rememberable, :trackable, :validatable

        attr_writer :group_service
      end

      module ClassMethods
        def find_by_user_key(key)
          self.send("find_by_#{Devise.authentication_keys.first}", key)
        end
      end

      # Copied from Hydra::User
      def user_key
        send(Devise.authentication_keys.first)
      end

      def group_service
        @group_service ||= RemoteGroupService.new
      end

      def to_s
        user_key
      end

      def ability
        @ability ||= ::Ability.new(self)
      end

      def groups
        @groups ||= group_service.user_groups(self)
      end

      def member_of?(group)
        group ? self.groups.include?(group) : false
      end
      
      def authorized_to_act_as_superuser?
        member_of? group_service.superuser_group
      end

      def principal_name
        user_key
      end

      def principals
        groups.dup << principal_name
      end

      def has_role?(obj, role)
        obj.principal_has_role?(principals, role)
      end

    end
  end
end
