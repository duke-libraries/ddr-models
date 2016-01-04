require "csv"

module Ddr::Index
  class CSVQueryResult < AbstractQueryResult

    MAX_ROWS = 10**8
    MV_SEP   = ";"

    attr_reader :mv_sep

    delegate :read, :each, to: :csv

    def initialize(query, mv_sep: MV_SEP)
      super(query)
      @mv_sep = mv_sep
    end

    def csv
      CSV.new(data, csv_opts.to_h)
    end

    def to_s
      read.to_csv
    end

    def rows
      query.rows || MAX_ROWS
    end

    def csv_opts
      @csv_opts ||= CSVOptions.new(headers: csv_headers)
    end

    def solr_csv_opts
      @solr_csv_opts ||= SolrCSVOptions.new(col_sep: csv_opts.col_sep,
                                            quote_char: csv_opts.quote_char,
                                            header: solr_csv_header,
                                            mv_sep: mv_sep,
                                            rows: rows)
    end

    def headers
      @headers ||= query.fields.map(&:heading)
    end

    def csv_headers
      if headers.empty?
        :first_row
      else
        headers
      end
    end

    def solr_csv_header
      csv_headers == :first_row
    end

    def solr_csv_params
      params.merge solr_csv_opts.params
    end

    def data
      raw = conn.get("select", params: solr_csv_params)
      raw.gsub(/\\#{mv_sep}/, mv_sep)
    end

  end
end
