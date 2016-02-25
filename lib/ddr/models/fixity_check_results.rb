require 'delegate'

module Ddr::Models
  class FixityCheckResults < SimpleDelegator

    def initialize
      super Hash.new
    end

    def success?
      values.all?
    end

  end
end
