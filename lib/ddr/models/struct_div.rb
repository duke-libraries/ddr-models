module Ddr
  module Models
    class StructDiv

      attr_accessor :id, :label, :order, :orderlabel, :type, :objs, :divs

      def initialize(structmap_or_div_node)
        @id = structmap_or_div_node['ID']
        @label = structmap_or_div_node['LABEL']
        @order = structmap_or_div_node['ORDER']
        @orderlabel = structmap_or_div_node['ORDERLABEL']
        @type = structmap_or_div_node['TYPE']
        @objs = obj_pids(structmap_or_div_node) if structmap_or_div_node.node_name == "div"
        @divs = subdivs(structmap_or_div_node).sort
      end

      def <=>(other)
        self.order.to_i <=> other.order.to_i
      end

      def objects?
        objs.present?
      end

      def object_pids
        objs
      end

      def objects
        objs.map { |pid| ActiveFedora::Base.find(pid) }
      end

      private

      def obj_pids(div_node)
        div_node.xpath('xmlns:fptr').map { |fptr_node| fptr_node["CONTENTIDS"].gsub('info:fedora/', '') }
      end

      def subdivs(structmap_or_div_node)
        structmap_or_div_node.xpath('xmlns:div').map { |div_node| Ddr::Models::StructDiv.new(div_node) }
      end

    end
  end
end