module Ddr
  module Models
    class StructDiv

      attr_accessor :id, :label, :order, :orderlabel, :type, :fptrs, :divs

      def initialize(structmap_or_div_node)
        @id = structmap_or_div_node['ID']
        @label = structmap_or_div_node['LABEL']
        @order = structmap_or_div_node['ORDER']
        @orderlabel = structmap_or_div_node['ORDERLABEL']
        @type = structmap_or_div_node['TYPE']
        @fptrs = fptr_pids(structmap_or_div_node) if structmap_or_div_node.node_name == "div"
        @divs = subdivs(structmap_or_div_node).sort
      end

      def <=>(other)
        self.order.to_i <=> other.order.to_i
      end

      def pids
        collect_pids(self)
      end

      def docs
        query = ActiveFedora::SolrQueryBuilder.construct_query_for_ids(pids)
        results = ActiveFedora::SolrService.query(query, rows: 999999)
        results.each_with_object({}) do |r, memo|
          memo[r["id"]] = ::SolrDocument.new(r)
        end
      end

      def objects
        pids.each_with_object({}) do |pid, memo|
          memo[pid] = ActiveFedora::Base.find(pid)
        end
      end

      def as_json(options={})
        super.compact
      end

      private

      def fptr_pids(div_node)
        div_node.xpath('xmlns:fptr').map { |fptr_node| fptr_node["CONTENTIDS"] }
      end

      def subdivs(structmap_or_div_node)
        structmap_or_div_node.xpath('xmlns:div').map { |div_node| Ddr::Models::StructDiv.new(div_node) }
      end

      def collect_pids(structdiv)
        pids = structdiv.divs.each_with_object([]) do |div, memo|
          memo << collect_pids(div)
        end
        pids << structdiv.fptrs if structdiv.fptrs
        pids.flatten
      end

    end
  end
end
