require "delegate"

module Ddr
  module Auth
    # Wraps a String
    class Group < SimpleDelegator

      attr_reader :rule

      def initialize(id, opts={}, &rule)
        super(id)
        @label = opts[:label]
        @rule = rule
        freeze
      end

      # @param user [Ddr::Auth::AuthContext]
      def has_member?(auth_context)
        rule ? instance_exec(auth_context, &rule) : auth_context.member_of?(self)
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

      def inspect
        "#<#{self.class.name} id=#{id.inspect}, label=#{label.inspect}>"
      end

    end
  end
end
