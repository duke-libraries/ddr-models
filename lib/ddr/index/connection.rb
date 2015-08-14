module Ddr::Index
  class Connection < SimpleDelegator

    def initialize
      super RSolr.connect(ActiveFedora.solr_config)
    end

    def select(params, extra={})
      Response.new get("select", params: params.merge(extra))
    end

    def page(*args)
      Response.new paginate(*args)
    end

  end
end
