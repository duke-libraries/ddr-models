require "delegate"

module Ddr
  module Auth
    # Wraps a String
    class Group < SimpleDelegator

      attr_reader :rule

      def initialize(id, opts={}, &block)
        super(id)
        @label = opts[:label]
        @rule = block
        freeze
      end

      # @param user [Ddr::Auth::User]      
      def has_member?(user)
        rule ? instance_exec(user, &rule) : user.member_of?(self)
      end

      def id
        __getobj__
      end

      def label
        @label || id
      end

      def agent
        to_s
      end

      def to_agent
        warn "[DEPRECATION] `#{self.class.name}#to_agent` is deprecated. Use `#{self.class.name}#agent instead."
        agent
      end

      def inspect
        "#<#{self.class.name} id=#{id.inspect}, label=#{label.inspect}>"
      end

    end
  end
end
