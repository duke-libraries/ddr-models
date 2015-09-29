module Ddr::Index
  class Response < SimpleDelegator

    def docs
      self["response"]["docs"]
    end

    def num_found
      self["response"]["numFound"].to_i
    end

  end
end
