module Ddr
  module Managers
    # @abstract
    class Manager

      attr_reader :object

      def initialize(object)
        @object = object
      end

    end
  end
end
