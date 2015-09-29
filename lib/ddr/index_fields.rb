module Ddr
  module IndexFields

    warn "[DEPRECATION] `Ddr::IndexFields` is deprecated and will be removed in ddr-models 3.0." \
         " Use `Ddr::Index::Fields` instead."

    include Ddr::Index::Fields

    def self.get(name)
      Ddr::Index::Fields.get(name)
    end

  end
end
