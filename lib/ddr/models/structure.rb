module Ddr::Models
  #
  # Wraps a Nokogiri (XML) 'mets' Document
  #
  class Structure < SimpleDelegator

    TYPE_DEFAULT = 'default'.freeze

    USE_ACCESS = 'access'.freeze
    USE_IMAGESERVER = 'imageserver'.freeze
    USE_MASTER = 'master'.freeze
    USE_THUMBNAIL = 'thumbnail'.freeze

    def filesec
      @filesec ||= Ddr::Models::Structures::FileSec.new(fileSec_node)
    end

    def files
      @files ||= collect_files(filesec)
    end

    def structmap(type=nil)
      sm = type ? structMap_node(type) : structMap_nodes.first
      @structmap ||= Ddr::Models::Structures::StructMap.new(sm)
    end

    def structmaps
      @structmaps ||= structMap_nodes.map { |sm| Ddr::Models::Structures::StructMap.new(sm) }
    end

    def metshdr
      @metshdr ||=  Ddr::Models::Structures::MetsHdr.new(metsHdr_node)
    end

    def creator
      @creator ||= metshdr.empty? ? nil
                                  : Ddr::Models::Structures::MetsHdr.new(metsHdr_node).agents.first.name
    end

    def repository_maintained?
      creator == Ddr::Models::Structures::Agent::NAME_REPOSITORY_DEFAULT
    end

    def dereferenced_structure
      deref_struct = {}
      structmaps.each do |sm|
        deref_struct[sm.type] = sm.dereferenced_hash
      end
      deref_struct
    end

    def as_xml_document
      __getobj__
    end

    def add_metshdr(id:nil, createdate:nil, lastmoddate:nil, recordstatus:nil)
      metshdr = Ddr::Models::Structures::MetsHdr.build(id: id, createdate: createdate, lastmoddate: lastmoddate,
                                                       recordstatus: recordstatus, document: as_xml_document)
      root.add_child(metshdr)
      metshdr
    end

    def add_agent(parent:, id:nil, role:, otherrole:nil, type:nil, othertype:nil, name:nil)
      agent = Ddr::Models::Structures::Agent.build(id: id, role: role, otherrole: otherrole, type: type,
                                                   othertype: othertype, name: name, document: as_xml_document)
      parent.add_child(agent)
      agent
    end

    def add_filesec(id:nil)
      filesec = Ddr::Models::Structures::FileSec.build(id: id, document: as_xml_document)
      root.add_child(filesec)
      filesec
    end

    def add_filegrp(parent:, id:nil, use:nil)
      filegrp = Ddr::Models::Structures::FileGrp.build(id: id, use: use, document: as_xml_document)
      parent.add_child(filegrp)
      filegrp
    end

    def add_file(parent:, id:SecureRandom.uuid, use:nil)
      file = Ddr::Models::Structures::File.build(id: id, use: use, document: as_xml_document)
      parent.add_child(file)
      file
    end

    def add_flocat(parent:, id:nil, loctype:'ARK', otherloctype: nil, use:nil, href:)
      flocat = Ddr::Models::Structures::FLocat.build(id: id, loctype: loctype, otherloctype: otherloctype, use: use,
                                                     href: href, document: as_xml_document)
      parent.add_child(flocat)
      flocat
    end

    def add_structmap(id:nil, label:nil, type:)
      structmap = Ddr::Models::Structures::StructMap.build(id: id, label: label, type: type, document: as_xml_document)
      root.add_child(structmap)
      structmap
    end

    def add_div(parent:, id:nil, label:nil, order:nil, orderlabel: nil, type:nil)
      div = Ddr::Models::Structures::Div.build(id: id, label: label, order:order, orderlabel: orderlabel, type: type,
                                               document: as_xml_document)
      parent.add_child(div)
      div
    end

    def add_fptr(parent:, id: nil, fileid:)
      fptr = Ddr::Models::Structures::Fptr.build(id: id, fileid: fileid, document: as_xml_document)
      parent.add_child(fptr)
      fptr
    end

    private

    def fileSec_node
      xpath("//xmlns:fileSec").first
    end

    def structMap_nodes
      xpath("//xmlns:structMap")
    end

    def structMap_node(type)
      xpath("//xmlns:structMap[@TYPE='#{type}']").first
    end

    def metsHdr_node
      xpath("//xmlns:metsHdr")
    end

    def collect_files(container)
      files = {}
      container.filegrps.each do |filegrp|
        files.merge!(collect_files(filegrp))
      end
      if container.respond_to?(:files)
        container.files.each do |file|
          files[file.id] = file
        end
      end
      files
    end

    def self.xml_template
      Nokogiri::XML(
          '<mets xmlns="http://www.loc.gov/METS/" xmlns:xlink="http://www.w3.org/1999/xlink" />'
          ) do |config|
              config.noblanks
            end
    end

  end
end
