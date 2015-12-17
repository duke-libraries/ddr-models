require "virtus"

module Ddr::Index
  class SortOrder
    include Virtus.value_object

    ASC = "asc"
    DESC = "desc"

    values do
      attribute :field, FieldAttribute
      attribute :order, String
    end

    def to_s
      [ field, order ].join(" ")
    end

    def self.asc(field)
      new(field: field, order: ASC)
    end

    def self.desc(field)
      new(field: field, order: DESC)
    end

  end
end
