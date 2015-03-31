module Ddr
  module Auth
    # @abstract
    class Affiliation < SimpleDelegator      

      private_class_method :new

      VALUES = [:faculty, :staff, :student, :emeritus, :affiliate, :alumni]

      VALUES.each do |value|
        const_set(value.to_s.capitalize, new(value))
      end

      def group
        Group.build("duke.#{self}")
      end

      def inspect
        "#<#{self.class.name}(#{self})>"
      end        

      class << self
        def all
          @all ||= VALUES.map { |value| get(value) }
        end

        def get(affiliation)
          const_get(affiliation.to_s.capitalize)
        end

        def group(affiliation)
          get(affiliation).group
        end

        def groups
          @groups ||= all.map(&:group)
        end
      end

    end
  end
end
