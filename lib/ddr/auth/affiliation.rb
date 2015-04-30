module Ddr
  module Auth
    # @abstract
    class Affiliation < SimpleDelegator

      private_class_method :new

      VALUES = %w( faculty staff student emeritus affiliate alumni ).freeze

      VALUES.each do |value|
        const_set(value.capitalize, new(value).freeze)
      end

      def group
        Group.new(group_name, label: label)
      end

      def label
        "Duke #{capitalize}"
      end

      def group_name
        "duke.#{self}"
      end

      def inspect
        "#<#{self.class.name}(#{__getobj__.inspect})>"
      end

      class << self
        def all
          @all ||= VALUES.map { |value| get(value) }
        end

        def get(affiliation)
          const_get(affiliation.capitalize)
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
