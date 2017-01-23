module Ddr::Models::Structures
  #
  # Wraps a Nokogiri (XML) 'FLocat' node
  #
  class FLocat < SimpleDelegator

    def id
      self['ID']
    end

    def loctype
      self['LOCTYPE']
    end

    def otherloctype
      self['OTHERLOCTYPE']
    end

    def use
      self['USE']
    end

    def href
      self['xlink:href']
    end

    def ark?
      loctype == 'ARK'
    end

    def ark
      href if ark?
    end

    def effective_use
      use ? use : File.new(parent).effective_use
    end

    def repo_id
      SolrDocument.find_by_permanent_id(ark).id if ark?
    end

    def self.build(args)
      node = Nokogiri::XML::Node.new('FLocat', args[:document])
      node['ID'] = args[:id] if args[:id]
      node['LOCTYPE'] = args[:loctype] if args[:loctype]
      node['OTHERLOCTYPE'] = args[:otherloctype] if args[:otherloctype]
      node['USE'] = args[:use] if args[:use]
      node['xlink:href'] = args[:href] if args[:href]
      node
    end

  end
end
