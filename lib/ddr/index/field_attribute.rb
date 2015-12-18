require "virtus"

module Ddr::Index
  class FieldAttribute < Virtus::Attribute

    def self.coerce(value)
      case value
      when Field
        value
      when String
        Field.new(value)
      when Symbol
        Fields.get(value)
      end
    end

    def coerce(value)
      self.class.coerce(value)
    end

  end
end
