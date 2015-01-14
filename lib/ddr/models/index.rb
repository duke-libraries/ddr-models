module Ddr
  module Models
    class Index

      attr_reader :name, :method

      def initialize(name, method)
        @name = name
        @method = method
      end

      def value(obj)
        if method.respond_to?(:call)
          obj.instance_exec(&method)
        else
          obj.send(method)
        end
      end

    end
  end
end
