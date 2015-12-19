require "hashie"

module Ddr::Index
  class SolrCSVOptions < Hashie::Trash

    property "csv.header",       from: :header,     default: false
    property "csv.separator",    from: :col_sep,    default: ","
    property "csv.encapsulator", from: :quote_char, default: '"'
    property "csv.mv.separator", from: :mv_sep,     default: ","
    property :wt,                default: "csv"
    property :rows

    def params
      to_h.reject { |k, v| v.nil? }
    end

  end
end
