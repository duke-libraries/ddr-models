module Ddr::Models::Structures
  #
  # Wraps a Nokogiri (XML) 'file' node
  #
  class File < SimpleDelegator

    def id
      self['ID']
    end

    def use
      self['USE']
    end

    def files
      xpath('xmlns:file').map { |node| File.new(node) }
    end

    def flocats
      xpath('xmlns:FLocat').map { |node| FLocat.new(node) }
    end

    def effective_use
      if use
        use
      else
        case parent.name
          when "file"
            File.new(parent).effective_use
          when "fileGrp"
            FileGrp.new(parent).effective_use
        end
      end
    end

    def repo_ids
      flocats.map(&:repo_id)
    end

    def self.build(args)
      node = Nokogiri::XML::Node.new('file', args[:document])
      node['ID'] = args[:id] if args[:id]
      node['USE'] = args[:use] if args[:use]
      node
    end

    def self.find(structure, fileid)
      structure.files[fileid]
    end

  end
end
