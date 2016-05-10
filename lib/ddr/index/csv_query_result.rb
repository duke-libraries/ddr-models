require "csv"

module Ddr::Index
  class CSVQueryResult < AbstractQueryResult

    delegate :[], :to_s, :to_csv, to: :table

    def delete_empty_columns!
      mode = table.mode
      table.by_col!.delete_if { |c, vals| vals.all?(&:nil?) }
      table.send("by_#{mode}!")
    end

    def each(&block)
      table.by_row!.each(&block)
    end

    def table
      @table ||= CSV.parse(data, csv_opts.to_h)
    end

    def csv_opts
      @csv_opts ||= CSVOptions.new(headers: csv_headers)
    end

    def solr_csv_opts
      @solr_csv_opts ||= SolrCSVOptions.new(col_sep: csv_opts.col_sep,
                                            quote_char: csv_opts.quote_char,
                                            header: solr_csv_header,
                                            rows: query.rows)
    end

    def headers
      @headers ||= query.fields.map { |f| f.respond_to?(:heading) ? f.heading : f.to_s }
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
      params.merge(solr_csv_opts.params)
    end

    def data
      raw = conn.get("select", params: solr_csv_params)
      mv_sep = solr_csv_opts["csv.mv.separator"]
      raw.gsub(/\\#{mv_sep}/, mv_sep)
    end

  end
end
