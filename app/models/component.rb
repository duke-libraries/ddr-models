#
# A Component is a part of an Item; the principal content-bearing repository resource.
#
# Examples: Page of a book, track of a recording, etc.
#
class Component < Ddr::Models::Base

  include Ddr::Models::Captionable
  include Ddr::Models::HasContent
  include Ddr::Models::HasIntermediateFile
  include Ddr::Models::HasMultiresImage
  include Ddr::Models::HasStructMetadata
  include Ddr::Models::Streamable

  belongs_to :parent, :property => :is_part_of, :class_name => 'Item'
  belongs_to :target, :property => :has_external_target, :class_name => 'Target'

  alias_method :item, :parent
  alias_method :item=, :parent=

  STRUCTURALLY_RELEVANT_DATASTREAMS = [ Ddr::Datastreams::CAPTION, Ddr::Datastreams::CONTENT,
                                        Ddr::Datastreams::INTERMEDIATE_FILE, Ddr::Datastreams::MULTIRES_IMAGE,
                                        Ddr::Datastreams::STREAMABLE_MEDIA, Ddr::Datastreams::THUMBNAIL ]

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
    build_default_structure
  end

  private

  def build_default_structure
    document = Ddr::Models::Structure.xml_template
    structure = Ddr::Models::Structure.new(document)
    metshdr = structure.add_metshdr
    structure.add_agent(parent: metshdr, role: Ddr::Models::Structures::Agent::ROLE_CREATOR,
                        name: Ddr::Models::Structures::Agent::NAME_REPOSITORY_DEFAULT)
    structmap = structure.add_structmap(type: Ddr::Models::Structure::TYPE_DEFAULT)
    if has_content?
      filesec = structure.add_filesec
      div = structure.add_div(parent: structmap)
      filegrp = structure.add_filegrp(parent: filesec)
      add_use_to_structure(structure, filegrp, div, Ddr::Models::Structure::USE_ORIGINAL_FILE,
                           Ddr::Datastreams::CONTENT)
      add_use_to_structure(structure, filegrp, div, Ddr::Models::Structure::USE_PRESERVATION_MASTER_FILE,
                           Ddr::Datastreams::CONTENT)
      add_use_to_structure(structure, filegrp, div, Ddr::Models::Structure::USE_INTERMEDIATE_FILE,
                           Ddr::Datastreams::INTERMEDIATE_FILE) if has_intermediate_file?
      add_service_file_uses_to_default_structure(structure, filegrp, div)
      add_use_to_structure(structure, filegrp, div, Ddr::Models::Structure::USE_THUMBNAIL_IMAGE,
                           Ddr::Datastreams::THUMBNAIL) if has_thumbnail?
      add_use_to_structure(structure, filegrp, div, Ddr::Models::Structure::USE_TRANSCRIPT,
                           Ddr::Datastreams::CAPTION) if captioned?

    end
    structure
  end

  def add_service_file_uses_to_default_structure(structure, filegrp, div)
    add_use_to_structure(structure, filegrp, div, Ddr::Models::Structure::USE_SERVICE_FILE,
                         Ddr::Datastreams::MULTIRES_IMAGE) if has_multires_image?
    add_use_to_structure(structure, filegrp, div, Ddr::Models::Structure::USE_SERVICE_FILE,
                         Ddr::Datastreams::STREAMABLE_MEDIA) if streamable?
    if !has_multires_image? && !streamable?
      add_use_to_structure(structure, filegrp, div, Ddr::Models::Structure::USE_SERVICE_FILE,
                           Ddr::Datastreams::CONTENT)
    end
  end

  def add_use_to_structure(structure, filegrp, div, use, datastream_name)
    file = structure.add_file(parent: filegrp, use: use)
    structure.add_flocat(parent: file, loctype: 'OTHER', otherloctype: 'AttachedFile', href: datastream_name)
    structure.add_fptr(parent: div, fileid: file['ID'])
  end

end
