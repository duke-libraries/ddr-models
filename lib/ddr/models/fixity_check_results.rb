require 'delegate'

module Ddr::Models
  class FixityCheckResults < SimpleDelegator

    def initialize
      super Hash.new.with_indifferent_access
    end

    def success?
      values.all?
    end

  end
end
