require "delegate"

module Ddr
  module Auth
    class Agents < SimpleDelegator

      def initialize(user)
        super(user.groups + [user.to_agent])
      end

    end
  end
end
      
