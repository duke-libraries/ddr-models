require "csv"

module Ddr::Index
  class CSVQueryResult < AbstractQueryResult

    MAX_ROWS   = 10**8
    CSV_MV_SEPARATOR = ";"

    DESCMD_HEADER_CONVERTER = lambda { |header|
      if term = Ddr::Models::DescriptiveMetadata.mapping[header.to_sym]
        term.unqualified_name.to_s
      else
        header
      end
    }

    delegate :headers, :to_s, :to_csv, to: :table

    def delete_empty_columns!
      table.by_col!.delete_if { |c, vals| vals.all?(&:nil?) }
    end

    def each(&block)
      table.by_row!.each(&block)
    end

    def [](index_or_header)
      table.by_col_or_row![index_or_header]
    end

    def table
      @table ||= CSV.parse(data, csv_opts)
    end

    def csv_opts
      { headers:           csv_headers,
        return_headers:    false,
        write_headers:     true,
        header_converters: [ DESCMD_HEADER_CONVERTER ],
      }
    end

    def solr_csv_opts
      { "csv.mv.separator" => CSV_MV_SEPARATOR,
        "csv.header"       => solr_csv_header?,
        "rows"             => solr_csv_rows,
        "wt"               => "csv",
      }
    end

    def query_field_headings
      query.fields.map { |f| f.respond_to?(:heading) ? f.heading : f.to_s }
    end

    def csv_headers
      query.fields.empty? ? :first_row : query_field_headings
    end

    def solr_csv_header?
      csv_headers == :first_row
    end

    def solr_csv_rows
      query.rows || MAX_ROWS
    end

    def solr_csv_params
      params.merge(solr_csv_opts)
    end

    def data
      raw = conn.get("select", params: solr_csv_params)
      raw.gsub(/\\#{CSV_MV_SEPARATOR}/, CSV_MV_SEPARATOR)
    end

  end
end
