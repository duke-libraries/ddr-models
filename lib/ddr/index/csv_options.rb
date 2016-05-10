require "csv"
require "hashie"

module Ddr::Index
  class CSVOptions < Hashie::Dash
    property :headers,        default: CSV::DEFAULT_OPTIONS[:headers]
    property :return_headers, default: false
    property :write_headers,  default: true
    property :col_sep,        default: CSV::DEFAULT_OPTIONS[:col_sep]
    property :quote_char,     default: CSV::DEFAULT_OPTIONS[:quote_char]
  end
end
