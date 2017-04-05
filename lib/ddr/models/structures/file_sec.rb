module Ddr::Models::Structures
  #
  # Wraps a Nokogiri (XML) 'fileSec' node
  #
  class FileSec < SimpleDelegator

    def id
      self['ID']
    end

    def filegrps
      xpath('xmlns:fileGrp').map { |node| FileGrp.new(node) }
    end

    def self.build(args)
      node = Nokogiri::XML::Node.new('fileSec', args[:document])
      node['ID'] = args[:id] if args[:id]
      node
    end

  end
end
