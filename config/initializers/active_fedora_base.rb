module ActiveFedora
  class Base

    def can_have_attachments?
      has_association? :attachments
    end

    def has_attachments?
      can_have_attachments? && attachments.size > 0
    end

    def can_have_children?
      has_association? :children
    end

    def has_children?
      can_have_children? and children.size > 0
    end

    def can_have_content?
      datastreams.include? "content"
    end

    def has_content?
      can_have_content? && content.has_content?
    end

    def describable?
      self.is_a? Ddr::Models::Describable
    end

    def governable?
      has_association? :admin_policy
    end

    def has_admin_policy?
      governable? && admin_policy.present?
    end

    def can_have_struct_metadata?
      datastreams.include? Ddr::Datastreams::STRUCT_METADATA
    end

    def has_struct_metadata?
      can_have_struct_metadata? && structMetadata.has_content?
    end

    def can_have_mezzanine?
      datastreams.include? Ddr::Datastreams::MEZZANINE
    end

    def has_mezzanine?
      can_have_mezzanine? && datastreams[Ddr::Datastreams::MEZZANINE].has_content?
    end

    def can_have_multires_image?
      datastreams.include? Ddr::Datastreams::MULTIRES_IMAGE
    end

    def has_multires_image?
      can_have_multires_image? && datastreams[Ddr::Datastreams::MULTIRES_IMAGE].has_content?
    end

    def can_have_thumbnail?
      datastreams.include? "thumbnail"
    end

    def has_thumbnail?
      can_have_thumbnail? && thumbnail.has_content?
    end

    def safe_id
      id.sub(/:/, "-")
    end

    # For duck-typing with SolrDocument
    def active_fedora_model
      self.class.to_s
    end

    def controller_name
      active_fedora_model.tableize
    end

    protected

    def has_association? assoc
      !association(assoc).nil?
    end

  end
end
