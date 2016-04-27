require "date"
require "edtf"

module Ddr::Models
  class YearFacet

    EARLIEST_YEAR = 1000
    LATEST_YEAR = Date.today.year + 100
    VALID_YEARS = (EARLIEST_YEAR..LATEST_YEAR)
    VALUE_SEP = /;/

    # Between 1965 and 1968
    BETWEEN = Regexp.new '\A([Bb]etween\s+)(\d{4})(\s+and\s+)(\d{4})\??\z'

    # circa 1920, ca. 1920, c1920 => 1920
    CIRCA = Regexp.new '\b(circa\s+|ca?\.\s*|c(?=\d{4}[^\d]*))'

    # 1935-1940 => 1935/1940
    YEAR_RANGE = Regexp.new '(?<=\d{4})-(?=\d{4})'

    # 1920s, 1920s?, 192u, 192-, 192-?, 192? => 192x
    DECADE = Regexp.new '(?<=\A\d{3})(-\??|0s\??|u|\?)\z'

    # 2010/01 => 2010-01
    MONTH = Regexp.new '(?<=\A\d{4})\/(?=\d{2}\z)'

    # 193u/, 193x/ => 1930/
    START_DECADE = Regexp.new '(?<=\d{3})[uxX](?=\/)'

    # /194x, /194u => /1949
    END_DECADE = Regexp.new '(?<=\/\d{3})[uxX]'

    # 19uu => 19xx
    CENTURY = Regexp.new '(?<=\A\d{2})uu(?=\z)'

    def self.call(object)
      new(object).call
    end

    attr_reader :object

    def initialize(object)
      @object = object
    end

    def call
      source_dates.each_with_object([]) do |date, facet_values|
        date.split(VALUE_SEP).each do |value|
          value.strip!
          edtf_date = convert_to_edtf(value)
          years = Array(edtf_years(edtf_date))
          years.select! { |year| VALID_YEARS.include?(year) }
          facet_values.push(*years)
        end
      end
    end

    private

    def source_dates
      object.desc_metadata.date
    end

    def convert_to_edtf(value)
      if m = BETWEEN.match(value)
        value.sub! m[1], ""  # [Bb]etween
        value.sub! m[3], "/" # and
      end
      substitutions.reduce(value) { |memo, (regexp, repl)| memo.gsub(regexp, repl) }
    end

    def substitutions
      [
        [ CIRCA,         "" ],
        [ YEAR_RANGE,   "/" ],
        [ DECADE,       "x" ],
        [ MONTH,        "-" ],
        [ START_DECADE, "0" ],
        [ END_DECADE,   "9" ],
        [ CENTURY,     "xx" ],
      ]
    end

    def edtf_years(value)
      case parsed = EDTF.parse!(value)
      when Date, EDTF::Season
        parsed.year
      when EDTF::Set, EDTF::Interval, EDTF::Epoch
        parsed.map(&:year).uniq
      end
    rescue ArgumentError # EDTF cannot parse
      nil
    end

  end
end
