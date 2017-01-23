module Ddr::Models::Structures
  #
  # Wraps a Nokogiri (XML) 'fptr' node
  #
  class Fptr < SimpleDelegator

    def id
      self['ID']
    end

    def fileid
      self['FILEID']
    end

    def dereferenced_hash
      structure = Ddr::Models::Structure.new(document)
      file = File.find(structure, fileid)
      repo_id = file.repo_ids.first
      use = file.flocats.first.effective_use
      { id: id, repo_id: repo_id, use: use }.compact
    end

    def self.build(args)
      node = Nokogiri::XML::Node.new('fptr', args[:document])
      node['ID'] = args[:id] if args[:id]
      node['FILEID'] = args[:fileid] if args[:fileid]
      node
    end

  end
end
