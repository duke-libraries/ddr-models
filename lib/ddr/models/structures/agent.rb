module Ddr::Models::Structures
  #
  # Wraps a Nokogiri (XML) 'agent' node
  #
  class Agent < SimpleDelegator

    ROLE_CREATOR = 'CREATOR'.freeze

    NAME_REPOSITORY_DEFAULT = 'REPOSITORY DEFAULT'.freeze

    def id
      self['ID']
    end

    def role
      self['ROLE']
    end

    def otherrole
      self['OTHERROLE']
    end

    def type
      self['TYPE']
    end

    def othertype
      self['OTHERTYPE']
    end

    def name
      xpath('xmlns:name').first.content
    end

    def self.build(args)
      node = Nokogiri::XML::Node.new('agent', args[:document])
      node['ID'] = args[:id] if args[:id]
      node['ROLE'] = args[:role] if args[:role]
      node['OTHERROLE'] = args[:otherrole] if args[:otherrole]
      node['TYPE'] = args[:type] if args[:type]
      node['OTHERTYPE'] = args[:othertype] if args[:othertype]
      name_node = Nokogiri::XML::Node.new('name', args[:document])
      name_node.content = args[:name]
      node.add_child(name_node)
      node
    end

  end
end
