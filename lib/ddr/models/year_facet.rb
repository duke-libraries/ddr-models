require "date"

module Ddr::Models
  class YearFacet

    EARLIEST_YEAR = 1000

    # Between 1965 and 1968
    BETWEEN = Regexp.new '\A([Bb]etween\s+)(\d{4})(\s+and\s+)(\d{4})\??\z'

    # YYYx (192x)
    # YYYX (192X)
    # YYY? (192?)
    # YYY- (192-)
    # YYY-? (192-?)
    IN_DECADE = Regexp.new '\A(\d{3})([xX\-]\??|\?)\z'

    # YYxx (19xx)
    IN_CENTURY = Regexp.new '\A(\d{2})xx\z'

    # YYY0s (1920s)
    # YYY0s? (1920s?)
    DECADE = Regexp.new '\A(\d{3}0)s\??\z'

    # YYYY-MM (2010-01)
    # YYYY/MM (2010/01)
    YEAR_MONTH = Regexp.new '\A(\d{4})[/-](0[1-9]|1[0-2])\z'

    # YYYY-YYYY (1935-2010)
    # YYYY/YYYY (1935/2010)
    YEAR_RANGE = Regexp.new '\A(\d{4})[/-](\d{4})\z'

    # YYYY (1979)
    YEAR = Regexp.new '\A\d{4}\z'

    SQUARE_BRACKETS = Regexp.new '[\[\]]'

    # c. 1920
    # ca. 1920
    # c1920
    CIRCA = Regexp.new '\b(circa\s+|ca?\.\s*|c(?=\d{4}[^\d]*))'

    class << self
      def call(obj)
        new(obj).values
      end
    end

    attr_reader :obj, :values

    def initialize(obj)
      @obj = obj
      @values = []
      facet_values
    end

    def facet_values
      obj.desc_metadata.date.each do |date|
        date.split(/;/).each do |value|
          clean! value
          years = extract_years(value)
          validate! years
          values.push *years
        end
      end
    end

    def extract_years(value)
      years = match_years(value) || parse_year(value)
      Array(years)
    end

    def clean!(value)
      value.strip!
      value.gsub! SQUARE_BRACKETS, ""
      value.gsub! CIRCA, ""
    end

    def validate!(years)
      years = years & valid_years.to_a
    end

    def parse_year(value)
      Date.parse(value).year
    rescue ArgumentError
      nil
    end

    def valid_years
      (EARLIEST_YEAR..latest_year)
    end

    def latest_year
      Date.today.year + 100
    end

    def match_years(value)
      result = match_year_range(value) ||
               match_year_month(value) ||
               match_year(value) ||
               match_in_decade(value) ||
               match_in_century(value) ||
               match_decade(value) ||
               match_between(value)
      first_year, last_year = Array(result).map(&:to_i)
      last_year ? (first_year..last_year) : first_year
    end

    def match_year_range(value)
      if m = YEAR_RANGE.match(value)
        m[1, 2]
      end
    end

    def match_year_month(value)
      if m = YEAR_MONTH.match(value)
        m[1]
      end
    end

    def match_year(value)
      if m = YEAR.match(value)
        value
      end
    end

    def match_in_decade(value)
      if m = IN_DECADE.match(value)
        [ "#{m[1]}0", "#{m[1]}9" ]
      end
    end

    def match_in_century(value)
      if m = IN_CENTURY.match(value)
        [ "#{m[1]}00", "#{m[1]}99" ]
      end
    end

    def match_decade(value)
      if m = DECADE.match(value)
        [ m[1], m[1].sub(/0\z/, "9") ]
      end
    end

    def match_between(value)
      if m = BETWEEN.match(value)
        value.sub! m[1], ""  # [Bb]etween
        value.sub! m[3], "-" # and
        match_year_range(value)
      end
    end

  end
end
