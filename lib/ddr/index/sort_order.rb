require "virtus"

module Ddr::Index
  class SortOrder
    include Virtus.value_object(strict: true)

    ASC = "asc"
    DESC = "desc"

    values do
      attribute :field, String
      attribute :order, String
    end

    def to_s
      [field, order].join(" ")
    end

  end
end
