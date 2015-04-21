require "delegate"

module Ddr
  module Auth
    # Wraps a String
    class Group < SimpleDelegator

      # The inverse of `Ddr::Auth::User#member_of?(group)`
      def has_member?(user)
        user.groups.include?(self)
      end

      def to_agent
        to_s
      end
      alias_method :agent, :to_agent

    end
  end
end
