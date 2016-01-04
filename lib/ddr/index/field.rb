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
      I18n.t "#{i18n_base}.label", default: base.titleize
    end

    def heading
      I18n.t "#{i18n_base}.heading", default: base
    end

    private

    def i18n_base
      "ddr.index.fields.#{base}"
    end

  end
end
