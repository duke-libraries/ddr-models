module Ddr
  module Auth
    module User
      extend ActiveSupport::Concern

      included do
        include Blacklight::User

        has_many :events, inverse_of: :user, class_name: "Ddr::Events::Event"

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

      def agent
        user_key
      end

      def ability
        # warn "[DEPRECATION] `Ddr::Auth::User#ability` is deprecated." \
        #      " In a web context, please use the `current_ability` helper." \
        #      " Otherwise, please use `Ddr::Auth::AbilityFactory.call(user)`" \
        #      " to create an ability instance for the user."
        @ability ||= AbilityFactory.call(self)
      end
      
    end
  end
end
