module Ddr::Models::Structures
  #
  # Wraps a Nokogiri (XML) 'structMap' node
  #
  class StructMap < SimpleDelegator

    def id
      self['ID']
    end

    def label
      self['LABEL']
    end

    def type
      self['TYPE']
    end

    def divs
      xpath('xmlns:div').map { |node| Div.new(node) }
    end

    def dereferenced_hash
      contents = []
      contents.concat(divs.map { |div| div.dereferenced_hash }) unless divs.empty?
      dh = { id: id, label: label, type: type }.compact
      dh[:contents] = contents unless contents.empty?
      dh
    end

    def self.build(args)
      node = Nokogiri::XML::Node.new('structMap', args[:document])
      node['ID'] = args[:id] if args[:id]
      node['LABEL'] = args[:label] if args[:label]
      node['TYPE'] = args[:type] if args[:type]
      node
    end

  end
end
