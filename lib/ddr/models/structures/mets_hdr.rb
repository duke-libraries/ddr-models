module Ddr::Models::Structures
  #
  # Wraps a Nokogiri (XML) 'metsHdr' node
  #
  class MetsHdr < SimpleDelegator

    def id
      self['ID']
    end

    def createdate
      self['CREATEDATE']
    end

    def lastmoddate
      self['LASTMODDATE']
    end

    def recordstatus
      self['RECORDSTATUS']
    end

    def agents
      xpath('xmlns:agent').map { |node| Agent.new(node) }
    end

    def self.build(args)
      node = Nokogiri::XML::Node.new('metsHdr', args[:document])
      node['ID'] = args[:id] if args[:id]
      node['CREATEDATE'] = args[:createdate] if args[:createdate]
      node['LASTMODDATE'] = args[:lastmoddate] if args[:lastmoddate]
      node['RECORDSTATUS'] = args[:recordstatus] if args[:recordstatus]
      node
    end

  end
end
