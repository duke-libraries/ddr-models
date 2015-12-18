require "virtus"

module Ddr::Index
  class FieldAttribute < Virtus::Attribute

    def coerce(value)
      case value
      when Field
        value
      when String
        Field.new(value)
      when Symbol
        Fields.get(value)
      end
    end

  end
end
