require "csv"

module Ddr::Index
  class CSVQueryResult < QueryResult

    COL_SEP    = CSV::DEFAULT_OPTIONS[:col_sep]
    QUOTE_CHAR = CSV::DEFAULT_OPTIONS[:quote_char]

    SOLR_CSV_OPTS = {
      "csv.header"       => "false",
      "csv.separator"    => COL_SEP,
      "csv.mv.separator" => "|",
      "csv.encapsulator" => QUOTE_CHAR,
      "wt"               => "csv",
    }

    def csv
      CSV.new(data,
              headers: headers,
              return_headers: true,
              write_headers: true,
              col_sep: COL_SEP,
              quote_char: QUOTE_CHAR)
    end

    def to_s
      csv.read
    end

    def data
      csv_params = params.merge(SOLR_CSV_OPTS)
      csv_params[:rows] ||= MAX_ROWS
      conn.get "select", params: csv_params
    end

    def headers
      query.fields.map(&:label)
    end

  end
end
