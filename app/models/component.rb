#
# A Component is a part of an Item; the principal content-bearing repository resource.
#
# Examples: Page of a book, track of a recording, etc.
#
class Component < Ddr::Models::Base

  include Ddr::Models::HasContent
  include Ddr::Models::HasIntermediateFile
  include Ddr::Models::HasMultiresImage
  include Ddr::Models::HasStructMetadata
  include Ddr::Models::Streamable

  belongs_to :parent, :property => :is_part_of, :class_name => 'Item'
  belongs_to :target, :property => :has_external_target, :class_name => 'Target'

  alias_method :item, :parent
  alias_method :item=, :parent=

  def collection
    self.parent.parent rescue nil
  end

  def collection_uri
    self.collection.internal_uri rescue nil
  end

  def publishable?
    parent.present? && parent.published?
  end

  def default_structure
    build_default_structure if has_content?
  end

  private

  def build_default_structure
    document = Ddr::Models::Structure.xml_template
    structure = Ddr::Models::Structure.new(document)
    metshdr = structure.add_metshdr
    structure.add_agent(parent: metshdr, role: Ddr::Models::Structures::Agent::ROLE_CREATOR,
                        name: Ddr::Models::Structures::Agent::NAME_REPOSITORY_DEFAULT)
    filesec = structure.add_filesec
    structmap = structure.add_structmap(type: Ddr::Models::Structure::TYPE_DEFAULT)
    div = structure.add_div(parent: structmap)
    filegrp = structure.add_filegrp(parent: filesec)
    add_original_file(structure, filegrp, div)
    add_preservation_master_file(structure, filegrp, div)
    add_intermediate_file(structure, filegrp, div) if has_intermediate_file?
    add_service_file(structure, filegrp, div)
    add_thumbnail_image(structure, filegrp, div) if has_thumbnail?
    structure
  end

  def add_original_file(structure, filegrp, div)
    file = structure.add_file(parent: filegrp, use: Ddr::Models::Structure::USE_ORIGINAL_FILE)
    structure.add_flocat(parent: file, loctype: 'OTHER', otherloctype: 'AttachedFile', href: Ddr::Datastreams::CONTENT)
    structure.add_fptr(parent: div, fileid: file['ID'])
  end

  def add_preservation_master_file(structure, filegrp, div)
    file = structure.add_file(parent: filegrp, use: Ddr::Models::Structure::USE_PRESERVATION_MASTER_FILE)
    structure.add_flocat(parent: file, loctype: 'OTHER', otherloctype: 'AttachedFile', href: Ddr::Datastreams::CONTENT)
    structure.add_fptr(parent: div, fileid: file['ID'])
  end

  def add_intermediate_file(structure, filegrp, div)
    file = structure.add_file(parent: filegrp, use: Ddr::Models::Structure::USE_INTERMEDIATE_FILE)
    structure.add_flocat(parent: file, loctype: 'OTHER', otherloctype: 'AttachedFile', href: Ddr::Datastreams::INTERMEDIATE_FILE)
    structure.add_fptr(parent: div, fileid: file['ID'])
  end

  def add_service_file(structure, filegrp, div)
    file = structure.add_file(parent: filegrp, use: Ddr::Models::Structure::USE_SERVICE_FILE)
    service_file = has_multires_image? ? Ddr::Datastreams::MULTIRES_IMAGE : Ddr::Datastreams::CONTENT
    structure.add_flocat(parent: file, loctype: 'OTHER', otherloctype: 'AttachedFile', href: service_file)
    structure.add_fptr(parent: div, fileid: file['ID'])
  end

  def add_thumbnail_image(structure, filegrp, div)
    file = structure.add_file(parent: filegrp, use: Ddr::Models::Structure::USE_THUMBNAIL_IMAGE)
    structure.add_flocat(parent: file, loctype: 'OTHER', otherloctype: 'AttachedFile', href: Ddr::Datastreams::THUMBNAIL)
    structure.add_fptr(parent: div, fileid: file['ID'])
  end

end
