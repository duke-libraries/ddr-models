module Ddr
  module Managers
    class RoleManager

      attr_reader :object

      def initialize(object)
        @object = object
      end

      def principal_has_role?(principal, role)
        ( principals(role) & Array(principal) ).any?
      end

      def principals(role)
        object.adminMetadata.send(role)
      end

      def method_missing(method, *args)
        if args.size == 0
          begin 
            return principals(method)
          rescue NoMethodError
          end
        end
        super
      end

    end
  end
end
