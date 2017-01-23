module Ddr::Models::Structures
  #
  # Wraps a Nokogiri (XML) 'div' node
  #
  class Div < SimpleDelegator

    def id
      self['ID']
    end

    def label
      self['LABEL']
    end

    def order
      self['ORDER']
    end

    def orderlabel
      self['ORDERLABEL']
    end

    def type
      self['TYPE']
    end

    def divs
      xpath('xmlns:div').map { |node| Div.new(node) }
    end

    def fptrs
      xpath('xmlns:fptr').map { |node| Fptr.new(node) }
    end

    def mptrs
      xpath('xmlns:mptr').map { |node| Mptr.new(node) }
    end

    def <=>(other)
      order.to_i <=> other.order.to_i
    end

    def dereferenced_hash
      contents = []
      contents.concat(divs.map { |div| div.dereferenced_hash }) unless divs.empty?
      contents.concat(fptrs.map { |fptr| fptr.dereferenced_hash }) unless fptrs.empty?
      contents.concat(mptrs.map { |mptr| mptr.dereferenced_hash }) unless mptrs.empty?
      dh = { id: id, label: label, order: order, orderlabel: orderlabel, type: type }.compact
      dh[:contents] = contents unless contents.empty?
      dh
    end

    def self.build(args)
      node = Nokogiri::XML::Node.new('div', args[:document])
      node['ID'] = args[:id] if args[:id]
      node['LABEL'] = args[:label] if args[:label]
      node['ORDER'] = args[:order] if args[:order]
      node['ORDERLABEL'] = args[:orderlabel] if args[:orderlabel]
      node['TYPE'] = args[:type] if args[:type]
      node
    end

  end
end
