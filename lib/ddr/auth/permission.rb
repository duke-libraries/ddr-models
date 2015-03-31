require "delegate"

module Ddr
  module Auth
    class Permission < SimpleDelegator

      VALUES = [:read, :download, :add_children, :edit, :replace, :arrange, :grant]

      VALUES.each do |value|
        const_set(value.to_s.camelize, new(value))
      end

      def inspect
        "#<#{self.class.name}(#{self})>"
      end

      class << self
        def all
          @all ||= VALUES.map { |value| get(value) }
        end

        def get(permission)
          const_get(permission.to_s.camelize)
        end
      end

    end
  end
end
