require "rsolr"
require "forwardable"

module Ddr::Index
  #
  # Wraps an RSolr connection
  #
  class Connection

    module Methods
      extend Forwardable

      delegate [:get, :post, :paginate] => :solr

      def solr
        RSolr.connect(ActiveFedora.solr_config)
      end

      def select(params, extra={})
        Response.new post("select", params: params.merge(extra))
      end

      def page(*args)
        Response.new paginate(*args)
      end

      def count(params)
        select(params, rows: 0).num_found
      end
    end

    extend Methods
    include Methods

  end
end
