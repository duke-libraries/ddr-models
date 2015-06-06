module Ddr
  module Auth
    module User
      extend ActiveSupport::Concern

      included do
        include Blacklight::User

        has_many :events, inverse_of: :user, class_name: "Ddr::Events::Event"

        attr_writer :groups

        delegate :can, :can?, :cannot, :cannot?, to: :ability

        validates_uniqueness_of :username, :case_sensitive => false
        validates_format_of :email, with: /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\z/

        devise :database_authenticatable, :omniauthable, omniauth_providers: [:shibboleth]

        class_attribute :user_key_attribute
        self.user_key_attribute = Devise.authentication_keys.first
      end

      module ClassMethods
        def find_by_user_key(key)
          send("find_by_#{user_key_attribute}", key)
        end

        def from_omniauth(auth)
          user = find_by_user_key(auth.uid) ||
            new(user_key_attribute => auth.uid, :password => Devise.friendly_token)
          user.update!(email: auth.info.email,
                       display_name: auth.info.name,
                       first_name: auth.info.first_name,
                       last_name: auth.info.last_name,
                       nickname: auth.info.nickname)
          user
        end
      end

      # Copied from Hydra::User
      def user_key
        send(user_key_attribute)
      end

      def to_s
        user_key
      end

      def to_agent
        principal_name
      end
      alias_method :agent, :to_agent

      def ability
        @ability ||= ::Ability.new(self)
      end

      def affiliations
        context.affiliation.map { |a| Affiliation.get(a.sub(/@duke\.edu\z/, "")) }.flatten
      end

      def context
        @context ||= Context.new
      end

      def context=(env)
        @context = env.is_a?(Context) ? env : Context.new(env)
        reset!
      end

      def groups
        @groups ||= calculate_groups
      end

      def member_of?(group)
        groups.include?(group.is_a?(Group) ? group : Group.new(group))
      end
      alias_method :is_member_of?, :member_of?

      def authorized_to_act_as_superuser?
        member_of?(Groups::Superusers)
      end

      def principal_name
        user_key
      end
      alias_method :name, :principal_name
      alias_method :eppn, :principal_name

      def agents
        groups.map(&:agent) << agent
      end

      def principals
        groups.map(&:to_s) + [principal_name]
      end

      def has_role?(obj, role)
        obj.principal_has_role?(principals, role)
      end

      private

      def calculate_groups
        groups = []
        groups.concat affiliations.map(&:group)
        groups.concat context.groups
        groups.concat dynamic_groups
        groups
      end

      def dynamic_groups
        Groups.dynamic.select { |group| group.has_member?(self) }
      end

      def reset!
        @ability = nil
        @groups = nil
      end

    end
  end
end
