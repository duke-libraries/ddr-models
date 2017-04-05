module Ddr::Models::Structures
  #
  # Wraps a Nokogiri (XML) 'fileGrp' node
  #
  class FileGrp < SimpleDelegator

    def id
      self['ID']
    end

    def use
      self['USE']
    end

    def filegrps
      xpath('xmlns:filegrp').map { |node| FileGrp.new(node) }
    end

    def files
      xpath('xmlns:file').map { |node| File.new(node) }
    end

    def effective_use
      use
    end

    def self.build(args)
      node = Nokogiri::XML::Node.new('fileGrp', args[:document])
      node['ID'] = args[:id] if args[:id]
      node['USE'] = args[:use] if args[:use]
      node
    end

  end
end
