require "delegate"

module Ddr
  module Auth
    # Wraps a String
    class Group < SimpleDelegator

      attr_reader :label

      def initialize(name, opts={})
        super(name)
        @label = opts.fetch(:label, name)
        freeze
      end

      # The inverse of `Ddr::Auth::User#member_of?(group)`
      def has_member?(user)
        user.groups.include?(self)
      end

      def to_agent
        to_s
      end
      alias_method :agent, :to_agent

      def inspect
        "#<#{self.class.name}(#{__getobj__.inspect}, label=#{label.inspect})>"
      end

    end
  end
end
