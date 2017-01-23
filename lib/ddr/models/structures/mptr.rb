module Ddr::Models::Structures
  #
  # Wraps a Nokogiri (XML) 'mptr' node
  #
  class Mptr < SimpleDelegator

    def id
      self['ID']
    end

    def loctype
      self['LOCTYPE']
    end

    def otherloctype
      self['OTHERLOCTYPE']
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

    def repo_id
      SolrDocument.find_by_permanent_id(ark).id if ark?
    end

    def dereferenced_hash
      { id: id, repo_id: repo_id }.compact
    end

    def self.build(args)
      node = Nokogiri::XML::Node.new('mptr', args[:document])
      node['ID'] = args[:id] if args[:id]
      node['LOCTYPE'] = args[:loctype] if args[:loctype]
      node['OTHERLOCTYPE'] = args[:otherloctype] if args[:otherloctype]
      node['xlink:href'] = args[:href] if args[:href]
      node
    end

  end
end
