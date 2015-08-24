module Ddr::Index
  class Field < SimpleDelegator

    attr_reader :base

    def initialize(base, *args)
      @base = base.to_s
      name = if args.empty?
               @base
             elsif args.last.is_a?(Hash) && args.last[:solr_name]
               args.last[:solr_name]
             else
               Solrizer.solr_name(base, *args)
             end
      super(name)
    end

    def label
      I18n.t "ddr.index.fields.#{base}", default: base.titleize
    end

  end
end
