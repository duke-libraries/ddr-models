module Ddr::Index
  module Filters
    extend Deprecation

    def self.is_governed_by(pid)
      Deprecation.warn(self,
                       "`Ddr::Index:Filters.is_governed_by` is deprecated and will be removed in ddr-models 3.0." \
                       " Use `Ddr::Index::Filter.is_governed_by` instead.")
      Filter.is_governed_by(pid)
    end

    private

    def self.const_missing(name)
      if name == :HAS_CONTENT
        Deprecation.warn(self,
                         "`Ddr::Index::Filters::#{name}` is deprecated and will be removed in ddr-models 3.0." \
                         " Use `Ddr::Index::Filter.has_content` instead.")
        Filter.has_content
      else
        super
      end
    end

  end
end
