require "hashie"

module Ddr::Index
  class SolrCSVOptions < Hashie::Trash

    MAX_ROWS   = 10**8
    CSV_MV_SEPARATOR = ";"

    property "csv.header",       from: :header,     default: false
    property "csv.separator",    from: :col_sep,    default: ","
    property "csv.encapsulator", from: :quote_char, default: '"'
    property "csv.mv.separator", default: CSV_MV_SEPARATOR
    property :wt,                default: "csv"
    property :rows,              default: MAX_ROWS

    def params
      to_h.reject { |k, v| v.nil? }
    end

  end
end
